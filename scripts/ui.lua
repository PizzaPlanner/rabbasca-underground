local M = { }

local warp = require("scripts.warp")

local ENERGY_PER_CELL = 1000000000

local function update_cost_button(button, recipe, cost_base)
    local n = 0.01 * (1 + (cost_base or 0)) * warp.get_fuel_time_modifier() * storage.stabilizer.config.recipe_settings[recipe].energy_required
    button.number = n
    button.style = n <= storage.stabilizer.charge.cells_stored and "inventory_slot" or "red_inventory_slot"
end

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

local function add_fuel_row(t, e)
    add_button(t, "entity/"..e.name, "inventory_slot", nil, 32)
    local bar = t.add {
        type = "progressbar",
        value = e.burner.remaining_burning_fuel / ENERGY_PER_CELL
    }
    bar.style.minimal_width = 72
    bar.style.natural_width = 72
    bar.style.horizontally_stretchable = true
    add_button(t, "item/rabbasca-warp-cell", "inventory_slot", nil, 32)
    add_button(t, "item/rabbasca-warp-cell-recharging", "inventory_slot", nil, 32)
end

function M.set_fuel_remote_ui(player)
    local frame = player.gui.relative.rabbasca_fuel_remote
    if (not storage.stabilizer) or player.opened ~= storage.stabilizer.fuel.recharger then
        if frame then frame.destroy() end
        return
    end
    if not frame then
        frame = player.gui.relative.add{
            type = "frame",
            name = "rabbasca_fuel_remote",
            caption = "Target",
            direction = "vertical",
            anchor = {
                gui = defines.relative_gui_type.proxy_container_gui,
                position = defines.relative_gui_position.right
            }
        }
        frame.add { 
            type = "drop-down", 
            name = "rabbasca_su_fuel_strategy",
            items = {
                {"", "Manual"},
                {"", "[item=rabbasca-warp-cell-recharging] = 0"},
                {"", "[item=rabbasca-warp-cell-recharging] > 0, [item=rabbasca-warp-trace] = 0"},
                {"", "[item=rabbasca-warp-cell] > 0"},
                {"", "[item=rabbasca-warp-cell] = 0"},
            }
        }
        frame.add { 
            type = "switch", 
            name = "rabbasca_su_fuel_retarget_switch",
            switch_state = "left",
            allow_none_state = false,
            left_label_caption = { "", "First" },
            right_label_caption = { "", "Cycle" },
            caption = { "", "Seek [item=rabbasca-warp-cell-recharging]" }, 
        }
        local t = frame.add{ 
            type = "table", 
            name = "targets",
            column_count = 4
        }
        for _, e in pairs(storage.stabilizer.fuel.consumers) do
            if e.valid then
                add_fuel_row(t, e)
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
    end
    local strategy = storage.stabilizer.fuel.selection_strategy
    local is_fuel_inv = storage.stabilizer.fuel.recharger.proxy_target_inventory == defines.inventory.fuel
    frame.rabbasca_su_fuel_retarget_switch.switch_state = strategy.cycle and "right" or "left"
    frame.rabbasca_su_fuel_strategy.selected_index = strategy.filter
    local current = storage.stabilizer.fuel.current
    local has_rows = #frame.targets.children / 4
    local i = 0
    for _, e in pairs(storage.stabilizer.fuel.consumers) do
        if e.valid then
            i = i + 1
            local id = i * 4 - 3
            if i > has_rows then
                add_fuel_row(frame.targets, e)
            end
            frame.targets.children[id    ].sprite = "entity/"..e.name
            frame.targets.children[id + 1].value  = e.burner.remaining_burning_fuel / ENERGY_PER_CELL
            frame.targets.children[id + 2].number = e.get_inventory(defines.inventory.fuel).get_item_count("rabbasca-warp-cell")
            frame.targets.children[id + 2].style  = i == current and is_fuel_inv and "yellow_inventory_slot" or "inventory_slot"
            frame.targets.children[id + 3].number = e.get_inventory(defines.inventory.burnt_result).get_item_count("rabbasca-warp-cell-recharging")
            frame.targets.children[id + 3].style  = i == current and (not is_fuel_inv) and "yellow_inventory_slot" or "inventory_slot"
            frame.targets.children[id + 2].style.size = 32
            frame.targets.children[id + 3].style.size = 32
        end
    end
    for j = 4 * (i + 1), #frame.targets.children do
        frame.targets.children[j].destroy()
    end
    if frame.cam0 then
        local pos = storage.stabilizer.fuel.consumers[current] and storage.stabilizer.fuel.consumers[current].valid and storage.stabilizer.fuel.consumers[current].position or {0, 0}
        frame.cam0.target_cam.position = pos
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

        local subframe = frame.add {
            type = "frame",
            name = "rabbasca_su_content",
            style = "entity_frame",
            direction = "vertical"
        }
        local f1 = subframe.add { type = "table", name = "rabbasca_su_table", column_count = 2 }

        -- Part Status
        local is_booted = storage.stabilizer.entity.force.technologies["rabbasca-warp-stabilizer"].researched
        f1.add { type = "label", caption = { "", "[entity=rabbasca-warp-stabilizer]" } }
        if is_booted then
            f1.add {
                type = "label",
                caption = { "", "[color=green]ONLINE[/color]" }
            }
        else
            local f2 = f1.add { type = "flow" }
            f2.add {
                type = "label",
                caption = { "", "[color=red]OFFLINE[/color]" }
            }
            add_button(f2, "virtual-signal/signal-anticlockwise-circle-arrow", "side_menu_button", "rabbasca_su_btn_reboot_main", 20)
        end

        f1.add { type = "line" } f1.add { type = "line" }

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
        local safe_zone_frame = subframe.add { type = "flow", direction = "horizontal", name = "miners" }
        safe_zone_frame.add { type = "label", caption = {"", "[entity=rabbasca-collector-pylon]"}}
        safe_zone_frame.add {
            type = "slider",
            name = "rabbasca_su_miners_target",
            style = "notched_slider",
            minimum_value = 0,
            maximum_value = storage.stabilizer.miners.available + (storage.stabilizer.miners.available < 2 and 0.000001 or 0),
            value_step = 1,
            value = storage.stabilizer.miners.active_target,
            discrete_values = true,
            tooltip = { "rabbasca-extra.panel-setting-radius" }
        }
        safe_zone_frame.add {
            type = "label",
            name = "energy_saved",
            caption = { "", "???"}
        }

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
    local empty_time = storage.stabilizer.charge.empty_since
    if t.rabbasca_su_status_extractor then
        t.rabbasca_su_status_extractor.caption = storage.stabilizer.parts.anomaly_extractor and ((empty_time or 0) > 0 and string.format("[color=yellow]Hibernate in %is[/color]", (storage.stabilizer.settings.miner_hibernation_timeout - empty_time)/60) or "[color=green]ONLINE[/color]") or "[color=yellow]SLEEP[/color]"
    end
    if t.rabbasca_su_status_relichunter then
        t.rabbasca_su_status_relichunter.caption = storage.stabilizer.parts.relichunter and ((empty_time or 0) > 0 and string.format("[color=yellow]Hibernate in %is[/color]", (storage.stabilizer.settings.miner_hibernation_timeout - empty_time)/60) or "[color=green]ONLINE[/color]") or "[color=yellow]SLEEP[/color]"
    end
    t.rabbasca_su_autopilot.switch_state = storage.stabilizer.settings.autopilot and "right" or "left"

    if frame.rabbasca_su_content.miners then
        frame.rabbasca_su_content.miners.rabbasca_su_miners_target.slider_value = storage.stabilizer.miners.active_target
        frame.rabbasca_su_content.miners.energy_saved.caption = "[item=rabbasca-warp-cell]"..string.format("%.1f%% | %i/%i", (storage.stabilizer.miners.saved_fuel or 0) *100 / ENERGY_PER_CELL, #storage.stabilizer.miners.entities, storage.stabilizer.miners.active_target)
    end

    if frame.rabbasca_su_fuelcosts then
        frame.rabbasca_su_fuelcosts.upkeep.caption = { "rabbasca-extra.panel-upkeep", storage.stabilizer.charge.upkeep }
        frame.rabbasca_su_fuelcosts.tank.caption = { "rabbasca-extra.panel-tank", string.format("%.2f", storage.stabilizer.charge.cells_stored) }
        update_cost_button(frame.rabbasca_su_fuelcosts.table.stabilize, "rabbasca-stabilize-warpfield")
        update_cost_button(frame.rabbasca_su_fuelcosts.table.warp, "rabbasca-stabilizer-warp-sequence", warp.get_warp_cost())
        update_cost_button(frame.rabbasca_su_fuelcosts.table.toggle_relichunter, "rabbasca-stabilizer-toggle-relichunter")
        update_cost_button(frame.rabbasca_su_fuelcosts.table.toggle_extractor, "rabbasca-stabilizer-toggle-extractor")
    end

    if frame.rabbasca_su_progress then
        frame.rabbasca_su_progress.bar.value = warp.get_repair_progress()
        frame.rabbasca_su_progress.bar.caption = { "rabbasca-extra.panel-progress", string.format("%.1f", warp.get_repair_progress() * 100), storage.stabilizer.anomalies.current }
    end
    if frame.relichunter_progress then
        frame.relichunter_progress.caption = { "", string.format("Relichunter: %i%% Chance", warp.get_relic_chance() * 100) }
    end

    -- frame.rabbasca_su_fuel.rabbasca_su_fuel_left.caption = { "", string.format("[item=rabbasca-warp-anomaly]Anomalies left: %i", storage.stabilizer.anomalies.current) }
    -- frame.rabbasca_su_fuel.rabbasca_su_repairs.caption =   { "", string.format("Stabilization:  %i%%", warp.get_repair_progress() * 100) }
    -- frame.rabbasca_su_fuel.rabbasca_su_cost_fix.caption =   { "", string.format("[recipe=rabbasca-stabilize-warpfield]: %.2f%%[item=rabbasca-warp-cell]/s", 1 * warp.get_fuel_time_modifier()) }
    -- frame.rabbasca_su_fuel.rabbasca_su_cost_warp.caption =   { "", string.format("[recipe=rabbasca-stabilizer-warp-sequence]: %.2f%%[item=rabbasca-warp-cell]/s", warp.get_warp_cost() * warp.get_fuel_time_modifier()) }
    -- frame.rabbasca_su_fuel.rabbasca_su_battery_drain.caption = { "", string.format("Current: %s%.2f%%[item=rabbasca-warp-cell]/s", info.discharge_rate > 0 and "+" or "", info.discharge_rate) }
end

return M