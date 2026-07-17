local M = { }

local warp = require("scripts.warp")
local fuel = require("scripts.fuel")

local function add_button(parent, sprite, style, name, size)
    local btn = parent.add{
        type = "sprite-button",
        sprite= sprite,
        style = style,
        name = name
    }
    btn.style.size = size
    return btn
end

function M.clear_stabilizer_ui(player)
    local frame = player.gui.relative.rabbasca_stabilizer_ui
    if frame then frame.destroy() end
end

function M.initiate_remote_assignment(player)
    storage.assign_remote_chest = storage.assign_remote_chest or { }
    storage.assign_remote_chest[player.index] = { chest = player.opened }
    player.opened = nil
end

local SUPPORTED_REMOTE_INVENTORY_TYPES = {
    ["crafter_input"] = true, 
    ["crafter_output"] = true, 
    ["crafter_trash"] = true, 
    ["fuel"] = true, 
    ["burnt_result"] = true, 
    ["rocket_silo_trash"] = true,
    ["chest"] = true,
    ["logistic_container_trash"] = true,
}
local SUPPORTED_REMOTE_TARGET_TYPES = {
    ["container"] = true,
    ["logistic-container"] = true,
    ["assembling-machine"] = true,
    ["rocket-silo"] = true,
    ["furnace"] = true,
}
function M.update_remote_assignment()
    if not storage.assign_remote_chest then return end
    local ticks_per_update = 10
    for player, data in pairs(storage.assign_remote_chest) do
        local p = game.get_player(player)
        if not (p and p.connected and data.chest and data.chest.valid and p.surface == data.chest.surface) then 
            storage.assign_remote_chest[player] = nil
            return
        end
        local pos = data.chest.position
        local range = data.chest.surface.name == "rabbasca-underground" and 32 or 10
        rendering.draw_rectangle({
            color = {0, 0.07, 0.25, 0.01},
            filled = true,
            left_top = { x = pos.x - range, y = pos.y - range },
            right_bottom = { x = pos.x + range, y = pos.y + range },
            surface = data.chest.surface,
            time_to_live = ticks_per_update,
            players = { player }
        })
        if p.opened then
            if p.opened == data.selected then 
                data.chest.proxy_target_entity = data.selected
                p.opened = data.chest
            end
            storage.assign_remote_chest[player] = nil
        elseif p.selected and p.selected.valid and SUPPORTED_REMOTE_TARGET_TYPES[p.selected.type] then
            local is_in_range = math.abs(data.chest.position.x - p.selected.position.x) < range and math.abs(data.chest.position.y - p.selected.position.y) < range
            if is_in_range then
                data.selected = p.selected
            end
            rendering.draw_line({
                surface = data.chest.surface, 
                players = { player }, 
                time_to_live = ticks_per_update, 
                from = data.chest, to = p.selected, 
                color = { 0, 0, 0 }, 
                width = 5, gap_length = 0.25, dash_length = 0.75})
            rendering.draw_line({
                surface = data.chest.surface, 
                players = { player }, 
                time_to_live = ticks_per_update, 
                from = data.chest, to = p.selected, 
                color = is_in_range and {1, 1, 1} or { 1, 0, 0 }, 
                width = 3, gap_length = 0.3, dash_length = 0.7, dash_offset = 0.025})
        end
    end
    if table_size(storage.assign_remote_chest) == 0 then storage.assign_remote_chest = nil end
end

function M.confirm_cell_selection(player)
    local frame = player.gui.screen.rabbasca_cell_assignment
    if frame then 
        local new_name = frame.rabbasca_cell_name.text
        local item = storage.assign_cell[player.index]
        if item and item.valid and item.valid_for_read and item.name:find("^rabbasca%-warp%-cell") then
            item.label = new_name
        end
        frame.destroy()
    end
    storage.assign_cell[player.index] = nil
end

function M.update_cell_assignment()
    if not storage.assign_cell then return end
    for player_index, _ in pairs(storage.assign_cell) do
        local player = game.get_player(player_index)
        if not player then 
            storage.assign_cell[player_index] = nil
        else
            M.set_cell_ui(player)
        end
    end
    if table_size(storage.assign_cell) == 0 then storage.assign_cell = nil end
end

local function add_table(parent)
    local t = parent.add{ type = "table", column_count = 8 }
    t.style.vertical_spacing = 1
    t.style.horizontal_spacing = 1
    return t
end

function M.set_cell_ui(player, item)
    local frame = player.gui.screen.rabbasca_cell_assignment
    if item and frame then frame.destroy() frame = nil end
    if not frame then
        frame = player.gui.screen.add{
            type = "frame",
            name = "rabbasca_cell_assignment",
            caption = { "", "Cell" },
            direction = "vertical"
        }
        frame.auto_center = true
        player.opened = nil -- close dummy inventory
        storage.assign_cell = storage.assign_cell or { }
        storage.assign_cell[player.index] = item
        local name = frame.add{ type = "textfield", name = "rabbasca_cell_name", caption = { "", "Cell Name" }, text = item and item.label or "", icon_selector = true, tooltip = {"", "Give the cell a custom name"} }
        local ok = frame.add{ type = "button", name = "rabbasca_cell_confirm", caption = { "", "Close" }, style = "confirm_button" }
        local scroll = frame.add { type = "scroll-pane", name = "rabbasca_cell_targets" }
        local all_targets = { }
        all_targets["empty"] = add_table(scroll)
        local btn = add_button(all_targets["empty"], nil, "inventory_slot", nil, 32)
        btn.tooltip = { "", "Remove tether, turn back into [item=rabbasca-warp-cell-recharging]"}
        btn.tags = { entity = 0 }
        for _, e in pairs(storage.stabilizer.fuel.consumers) do
            if e.entity.valid then
                local parent = all_targets[e.entity.name]
                if not parent then
                    parent = add_table(scroll)
                    all_targets[e.entity.name] = parent
                end
                local btn = add_button(parent, "entity/"..e.entity.name, "inventory_slot", nil, 32)
                btn.number = 0
                btn.elem_tooltip = { type = "entity", name = e.entity.name, quality = e.entity.quality }
                btn.tags = { entity = e.entity.unit_number }
                btn.show_percent_for_small_numbers = true
            end
        end
        local cam = frame.add{ name = "cam0", style = "entity_frame", type = "frame" }.add {
            type = "camera",
            name = "target_cam",
            position = { 0, 0 },
            surface_index = storage.stabilizer.surface,
            zoom = 0.5
        }
        cam.parent.style.padding = 0
        cam.style.horizontally_stretchable = true
        cam.style.vertically_stretchable   = true
        cam.style.minimal_height = 128
    else
        item = item or storage.assign_cell[player.index]
        storage.assign_cell[player.index] = item
    end

    if not (item and item.valid and item.valid_for_read and item.name:find("^rabbasca%-warp%-cell")) then
        storage.assign_cell[player.index] = nil
        frame.destroy()
        return
    end

    local data = item.item_number and storage.stabilizer.fuel.cells[item.item_number]
    if (not data) or (item.owner_location and item.owner_location.surface) then
        data = fuel.untether(item.item, true)
        item = data.item.item_stack
        storage.assign_cell[player.index] = item
    end

    local selected_number = player.selected and player.selected.valid and player.selected.unit_number
    local open_number = player.opened and player.opened_gui_type == defines.gui_type.entity and player.opened.unit_number
    local current = data.tether and data.tether.valid and data.tether
    local cam_target = current
    for _, parent in pairs(frame.rabbasca_cell_targets.children) do
        for _, elm in pairs(parent.children) do
            local is_hovered = selected_number == elm.tags.entity or player.selected == elm
            local is_open = open_number == elm.tags.entity
            local is_highlighted = current and current.unit_number == elm.tags.entity or is_hovered
            elm.style = is_highlighted and "yellow_inventory_slot" or "inventory_slot"
            local target = game.get_entity_by_unit_number(elm.tags.entity)
                if target and target.burner and target.burner.currently_burning then
                    elm.number = target.burner.remaining_burning_fuel / (target.burner.currently_burning.name.fuel_value or 1)
                else 
                    elm.number = 0
                end
            if is_hovered then
                cam_target = target
            end
            if is_open then -- selected a target by opening it in the world
                fuel.tether(item.item, player.opened, player)
            end
        end
    end
    frame.cam0.target_cam.position = cam_target and cam_target.position or { 10000, 0 }
    frame.cam0.target_cam.surface_index = cam_target and cam_target.surface.index or storage.stabilizer.surface

    if frame.current_target then
        frame.current_target.caption = { "", "Current Target: ", current and ("[entity="..current.name.."]") or "None" }
    end
    if frame.cam0 then
        frame.cam0.target_cam.position = current and current.position or { 10000, 0 }
        frame.cam0.target_cam.surface_index = current and current.surface.index or storage.stabilizer.surface
    end
end

function M.set_remote_access_ui(player)
    local frame = player.gui.relative.rabbasca_remote_access
    if (not player.opened) or player.opened.name ~= "rabbasca-remote-access-chest" then
        if frame then frame.destroy() end
        return
    end
    if not frame then
        frame = player.gui.relative.add{
            type = "frame",
            name = "rabbasca_remote_access",
            caption = "Target",
            direction = "vertical",
            anchor = {
                gui = defines.relative_gui_type.proxy_container_gui,
                position = defines.relative_gui_position.right
            }
        }
        frame.add { type = "button", caption = {"", "Select target"}, name = "rabbasca_remote_access_retarget" }
        local target = player.opened.proxy_target_entity
        if target and target.valid then
            local items = { }
            local selected = 0
            local count = 0
            for i = 1, target.get_max_inventory_index() do
                local inv = target.get_inventory(i)
                if inv and SUPPORTED_REMOTE_INVENTORY_TYPES[inv.name] and #inv > 0 then
                    table.insert(items, { "inventory-name."..inv.name, i })
                    count = count + 1
                    if player.opened.proxy_target_inventory == i then
                        selected = count
                    end
                end
            end
            frame.add{ 
                type = "list-box", 
                name = "rabbasca_remote_target_inventory",
                items = items,
                selected_index = selected
            }
        end
    end
end

function M.set_relicary_remote_ui(player)
    local frame = player.gui.relative.rabbasca_relicary_remote
    if (not player.opened) or player.opened.name ~= "rabbasca-relicary-remote" then
        if frame then frame.destroy() end
        return
    end
    if not frame then
        frame = player.gui.relative.add{
            type = "frame",
            name = "rabbasca_relicary_remote",
            caption = "Target",
            direction = "vertical",
            anchor = {
                gui = defines.relative_gui_type.proxy_container_gui,
                position = defines.relative_gui_position.right
            }
        }
        if not (player.opened.proxy_target_entity and player.opened.proxy_target_entity.valid) then
            frame.add { type = "button", caption = {"", "Attempt link"}, name = "rabbasca_relicary_reconnect" }
        end
        local list = frame.add{ 
            type = "list-box", 
            name = "rabbasca_relicary_target_inventory",
            items = { {"", "Input"}, {"", "Output"}, {"", "Fuel"} }
        }
        list.selected_index = (player.opened.proxy_target_inventory == defines.inventory.crafter_input and 1) 
                           or (player.opened.proxy_target_inventory == defines.inventory.crafter_output and 2) 
                           or (player.opened.proxy_target_inventory == defines.inventory.fuel and 3)
                           or 0 
    end
end

function M.set_stabilizer_ui(player)
    local frame = player.gui.relative.rabbasca_stabilizer_ui
    if (not storage.stabilizer) or player.opened ~= storage.stabilizer.entity then
        if frame then frame.destroy() end
        return
    end
    local recipe = storage.stabilizer.entity.get_recipe()
    local anchor = recipe == nil and defines.relative_gui_type.assembling_machine_select_recipe_gui or defines.relative_gui_type.assembling_machine_gui
    if frame and frame.anchor.gui ~= anchor then
        frame.destroy()
        return
    end
    if not frame then
        frame = player.gui.relative.add{
            type = "frame",
            name = "rabbasca_stabilizer_ui",
            caption = "Control Panel",
            direction = "vertical",
            anchor = {
                gui = recipe == nil and defines.relative_gui_type.assembling_machine_select_recipe_gui or defines.relative_gui_type.assembling_machine_gui,
                position = defines.relative_gui_position.right
            }
        }

        -- Progress
        local f1 = frame.add {
            type = "frame",
            name = "rabbasca_su_progress",
            style = "entity_frame",
            direction = "horizontal"
        }
        add_button(f1, "entity/rabbasca-warp-anomaly", "transparent_slot", "icon", 24)
        local bar2 = f1.add {
            type = "progressbar",
            name = "bar",
            value = 0,
            style = "production_progressbar",
            caption = "100% Stable",
            tooltip = { "rabbasca-extra.panel-progress-tooltip", storage.stabilizer.anomalies.initial }
        }
        bar2.style.minimal_width = 64
        bar2.style.natural_width = 64
        bar2.style.horizontal_align = "center"
        bar2.style.horizontally_stretchable = true
        bar2.style.color = { 1, 1, 1 }

        f1 = frame.add {
            type = "frame",
            name = "rabbasca_su_progress_ps",
            style = "entity_frame",
            direction = "horizontal"
        }
        add_button(f1, "item/rabbasca-powerspike", "transparent_slot", "icon", 24)
        bar2 = f1.add {
            type = "progressbar",
            name = "bar",
            value = 0,
            style = "production_progressbar",
            caption = "Level 0 - 100%",
        }
        bar2.style.minimal_width = 64
        bar2.style.natural_width = 64
        bar2.style.horizontal_align = "center"
        bar2.style.horizontally_stretchable = true
        bar2.style.color = { 1, 1, 1 }

        local subframe = frame.add {
            type = "frame",
            name = "rabbasca_su_stats_warp",
            style = "entity_frame",
            direction = "vertical"
        }
        local f1 = subframe.add { type = "table", name = "rabbasca_su_table", column_count = 2 }

        -- Settings
        f1.add {
            type = "label",
            caption = { "", "[virtual-signal=rabbasca-warp-inventory] Autopilot" },
        }
        f1.add {
            type = "switch",
            name = "rabbasca_su_autopilot",
            left_label_caption = "",
            right_label_caption = { "", "Enabled" }
        }
        subframe.add {
            type = "label",
            caption = { "rabbasca-extra.ui-warps-without-incident-label", string.format("%i", storage.stabilizer.finished_warps or 0) }
        }
        subframe.add {
            type = "label",
            caption = { "rabbasca-extra.ui-next-warp-target-label" }
        }
        local chances = warp.get_next_planet_chances()
        local f1 = subframe.add { type = "flow", name = "chances" }
        f1.style.horizontal_spacing = 4
        for p, chance in pairs(chances) do
            local b = add_button(f1, "space-location/"..p, "transparent_slot", p, 30)
            b.show_percent_for_small_numbers = true
            b.number = chance
        end
        subframe.add {
            type = "label",
            caption = { "rabbasca-extra.ui-anomaly-yield", string.format("%i", warp.get_next_anomaly_richness() * 100) }
        }
        subframe.add {
            type = "label",
            caption = { "rabbasca-extra.ui-find-relicary-chance", string.format("%.1f", warp.get_relic_chance() * 100) }
        }

        local inv_frame = frame.add{ type = "frame", style = "entity_frame", name = "rabbasca_su_warpcell_frame", direction = "vertical" }
        inv_frame.add {
            type = "switch",
            name = "rabbasca_su_warpcell_freeze",
            left_label_caption = { "", "[virtual-signal=signal-fuel] On" },
            right_label_caption = { "", "Paused [virtual-signal=signal-moon]" },
            tooltip = { "", "When paused, [item=rabbasca-warp-cell] will not power their targets, but also not lose or restore charge (freshness)" }
        }
        local inv = inv_frame.add{
            type = "inventory",
            slots_per_row = 5,
            handle_cursor_transfer = false,
            handle_cursor_split = false,
            handle_open_item = true,
            handle_open_mod_item = true,
            handle_send_stack_to_trash = false,
            handle_send_stacks_to_trash = false,
        }
        inv.inventory = storage.stabilizer.fuel.inventory
    end
    local t = frame.rabbasca_su_stats_warp.rabbasca_su_table
    t.rabbasca_su_autopilot.switch_state = storage.stabilizer.settings.autopilot and "right" or "left"
    
    local t2 = frame.rabbasca_su_warpcell_frame
    if t2 and t2.rabbasca_su_warpcell_freeze then
        t2.rabbasca_su_warpcell_freeze.switch_state = storage.stabilizer.fuel.is_frozen and "right" or "left"
    end

    if frame.rabbasca_su_progress then
        frame.rabbasca_su_progress.bar.value = warp.get_repair_progress()
        frame.rabbasca_su_progress.bar.caption = { "rabbasca-extra.panel-progress", string.format("%.1f", warp.get_repair_progress() * 100), storage.stabilizer.anomalies.current }
    end
    if frame.rabbasca_su_progress_ps then
        local level = storage.stabilizer.powerspikes.created
        local progress = 1 - storage.stabilizer.powerspikes.next / storage.stabilizer.powerspikes.required
        frame.rabbasca_su_progress_ps.bar.value = progress
        frame.rabbasca_su_progress_ps.bar.caption = { "rabbasca-extra.panel-progress-spike", level + 1, storage.stabilizer.powerspikes.next }
    end
end

return M