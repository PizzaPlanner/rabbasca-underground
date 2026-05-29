local M = { }

local warp = require("scripts.warp")
local fuel = require("scripts.fuel")

local ENERGY_PER_CELL = 1000000000

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

local function update_remote_assignment()
    if not storage.assign_remote then return end
    for player, data in pairs(storage.assign_remote) do
        local p = game.get_player(player)
        if not (p and data.chest and data.chest.valid and p.surface == data.chest.surface) then 
            storage.assign_remote[player] = nil
            return
        end
        local pos = data.chest.position
        rendering.draw_rectangle({
            color = {0, 0.07, 0.25, 0.01},
            filled = true,
            left_top = { x = pos.x - 10, y = pos.y - 10 },
            right_bottom = { x = pos.x + 10, y = pos.y + 10 },
            surface = data.chest.surface,
            time_to_live = 1,
            players = { player }
        })
        if p.opened then
            if p.opened == data.selected then 
                data.chest.proxy_target_entity = data.selected
                data.chest.proxy_target_inventory = defines.inventory.burnt_result
                p.opened = data.chest
            end
            storage.assign_remote[player] = nil
        elseif p.selected and p.selected.burner and p.selected.burner.fuel_categories["rabbasca-warp-anomaly"] then
            local is_in_range = math.abs(data.chest.position.x - p.selected.position.x) < 10 and math.abs(data.chest.position.y - p.selected.position.y) < 10
            if is_in_range then
                data.selected = p.selected
            end
            rendering.draw_line({
                surface = data.chest.surface, 
                players = { player }, 
                time_to_live = 1, 
                from = data.chest, to = p.selected, 
                color = { 0, 0, 0 }, 
                width = 5, gap_length = 0.25, dash_length = 0.75})
            rendering.draw_line({
                surface = data.chest.surface, 
                players = { player }, 
                time_to_live = 1, 
                from = data.chest, to = p.selected, 
                color = is_in_range and {1, 1, 1} or { 1, 0, 0 }, 
                width = 3, gap_length = 0.3, dash_length = 0.7, dash_offset = 0.025})
        end
    end
    if table_size(storage.assign_remote) == 0 then storage.assign_remote = nil end
end

function M.confirm_cell_selection(player)
    local frame = player.gui.screen.rabbasca_cell_assignment
    if frame then 
        local new_name = frame.rabbasca_cell_name.text
        local item = storage.assign_remote[player.index]
        if item and item.valid and item.valid_for_read and (item.name == "rabbasca-warp-cell" or item.name == "rabbasca-warp-cell-recharging") then
            item.label = new_name
        end
        frame.destroy()
    end
    storage.assign_remote[player.index] = nil
end

function M.update_cell_assignment()
    if not storage.assign_remote then return end
    for player_index, _ in pairs(storage.assign_remote) do
        local player = game.get_player(player_index)
        if not player then 
            storage.assign_remote[player_index] = nil
        else
            M.set_cell_ui(player)
        end
    end
    if table_size(storage.assign_remote) == 0 then storage.assign_remote = nil end
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
        storage.assign_remote = storage.assign_remote or { }
        storage.assign_remote[player.index] = item
        local name = frame.add{ type = "textfield", name = "rabbasca_cell_name", caption = { "", "Cell Name" }, text = item and item.label or "", icon_selector = true, tooltip = {"", "Give the cell a custom name"} }
        local ok = frame.add{ type = "button", name = "rabbasca_cell_confirm", caption = { "", "Close" }, style = "confirm_button" }
        local all_targets = frame.add{ type = "flow", name = "rabbasca_cell_targets", direction = "horizontal" }
        local btn = add_button(all_targets, nil, "inventory_slot", nil, 32)
        btn.tooltip = { "", "Remove tether, turn back into [item=rabbasca-warp-cell-recharging]"}
        btn.tags = { entity = 0 }
        for _, e in pairs(storage.stabilizer.fuel.consumers) do
            if e.entity.valid then
                local btn = add_button(all_targets, "entity/"..e.entity.name, "inventory_slot", nil, 32)
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
        item = item or storage.assign_remote[player.index]
        storage.assign_remote[player.index] = item
    end

    if not (item and item.valid and item.valid_for_read and (item.name == "rabbasca-warp-cell" or item.name == "rabbasca-warp-cell-recharging")) then
        storage.assign_remote[player.index] = nil
        frame.destroy()
        return
    end

    local data = item.item_number and storage.stabilizer.fuel.cells[item.item_number]
    if not data then 
        fuel.untether(item.item)
        data = storage.stabilizer.fuel.cells[item.item_number]
    end

    local selected_number = player.selected and player.selected.valid and player.selected.unit_number
    local open_number = player.opened and player.opened_gui_type == defines.gui_type.entity and player.opened.unit_number
    local current = data.tether and data.tether.valid and data.tether
    local cam_target = current
    for _, elm in pairs(frame.rabbasca_cell_targets.children) do
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
        if is_open then
            fuel.tether(item.item, player.opened)
        end
    end
    frame.cam0.target_cam.position = cam_target and cam_target.position or { 10000, 0 }
    frame.cam0.target_cam.surface_index = cam_target and cam_target.surface.index or storage.stabilizer.surface

    -- if player.opened and player.opened_gui_type == defines.gui_type.entity then
    --     storage.assign_remote[player.index] = nil
    --     frame.destroy()
    --     return
    -- end

    if frame.current_target then
        frame.current_target.caption = { "", "Current Target: ", current and ("[entity="..current.name.."]") or "None" }
    end
    if frame.cam0 then
        frame.cam0.target_cam.position = current and current.position or { 10000, 0 }
        frame.cam0.target_cam.surface_index = current and current.surface.index or storage.stabilizer.surface
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
            items = { {"", "Relic input"}, {"", "Relic output"}, {"", "Security lock"}, {"", "Security access"}}
        }
        list.selected_index = (player.opened.proxy_target_inventory == defines.inventory.crafter_input and 1) 
                           or (player.opened.proxy_target_inventory == defines.inventory.crafter_output and 2) 
                           or (player.opened.proxy_target_inventory == defines.inventory.fuel and 3)
                           or (player.opened.proxy_target_inventory == defines.inventory.burnt_result and 4)
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

        if storage.stabilizer.fuel.load then
            local f1 = frame.add {
                type = "frame",
                name = "rabbasca_su_drain",
                style = "entity_frame",
                direction = "horizontal"
            }
            add_button(f1, "item/rabbasca-warp-cell", "transparent_slot", "icon", 24)
            local bar2 = f1.add {
                type = "progressbar",
                name = "bar",
                value = 0,
                style = "production_progressbar",
                caption = "0/0 MW",
            }
            bar2.style.minimal_width = 64
            bar2.style.natural_width = 64
            bar2.style.horizontal_align = "center"
            bar2.style.horizontally_stretchable = true
            bar2.style.color = { 1, 1, 1 }
        end

        local subframe = frame.add {
            type = "frame",
            name = "rabbasca_su_content",
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
        local consumer_count = subframe.add { type = "flow" }
        local consumers = { }
        for _, e in pairs(storage.stabilizer.fuel.consumers) do
            if e.entity.valid then
                consumers[e.entity.name] = (consumers[e.entity.name] or 0) + 1
            end
        end
        for name, c in pairs(consumers) do
            add_button(consumer_count, "entity/"..name, "transparent_slot", nil, 24).number = c
        end

        local subframe = frame.add {
            type = "frame",
            name = "rabbasca_su_stats_warp",
            style = "entity_frame",
            direction = "vertical"
        }
        subframe.add {
            type = "label",
            caption = { "", string.format("[font=default-bold]%i[/font] warps without incident", storage.stabilizer.finished_warps or 0) }
        }
        subframe.add {
            type = "label",
            caption = { "", "Next [recipe=rabbasca-stabilizer-warp-sequence] target:" }
        }
        local chances = warp.get_next_planet_chances()
        local f1 = subframe.add { type = "flow", name = "chances" }
        f1.style.horizontal_spacing = 4
        for p, chance in pairs(chances) do
            local b = add_button(f1, "space-location/"..p, "transparent_slot", p, 30)
            b.show_percent_for_small_numbers = true
            b.number = chance
        end
    end
    local t = frame.rabbasca_su_content.rabbasca_su_table
    t.rabbasca_su_autopilot.switch_state = storage.stabilizer.settings.autopilot and "right" or "left"

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
    if frame.rabbasca_su_drain then
        local load = storage.stabilizer.fuel.load
        local val = load.available / load.demand
        frame.rabbasca_su_drain.bar.value = val
        frame.rabbasca_su_drain.bar.style.color = (val >= 1 and { 0, 1, 0 }) or (val > 0.5 and { 1, 0.8, 0 }) or { 1, 0.2, 0 }
        frame.rabbasca_su_drain.bar.caption = { "", string.format("%.1f MW / %.1f MW", load.available / 1000000 * 60, load.demand / 1000000 * 60) }
    end

    -- frame.rabbasca_su_fuel.rabbasca_su_fuel_left.caption = { "", string.format("[item=rabbasca-warp-anomaly]Anomalies left: %i", storage.stabilizer.anomalies.current) }
    -- frame.rabbasca_su_fuel.rabbasca_su_repairs.caption =   { "", string.format("Stabilization:  %i%%", warp.get_repair_progress() * 100) }
    -- frame.rabbasca_su_fuel.rabbasca_su_cost_fix.caption =   { "", string.format("[recipe=rabbasca-warp-trace]: %.2f%%[item=rabbasca-warp-cell]/s", 1 * warp.get_fuel_time_modifier()) }
    -- frame.rabbasca_su_fuel.rabbasca_su_cost_warp.caption =   { "", string.format("[recipe=rabbasca-stabilizer-warp-sequence]: %.2f%%[item=rabbasca-warp-cell]/s", warp.get_warp_cost() * warp.get_fuel_time_modifier()) }
    -- frame.rabbasca_su_fuel.rabbasca_su_battery_drain.caption = { "", string.format("Current: %s%.2f%%[item=rabbasca-warp-cell]/s", info.discharge_rate > 0 and "+" or "", info.discharge_rate) }
end

return M