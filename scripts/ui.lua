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

local function add_fuel_row(t, e)
    local b = add_button(t, "entity/"..e.name, "inventory_slot", nil, 32)
    b.show_percent_for_small_numbers = true
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
    if (not player.opened) or player.opened.name ~= "rabbasca-fuel-remote" then
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
            type = "switch", 
            name = "rabbasca_su_fuel_signal_switch",
            switch_state = "left",
            allow_none_state = false,
            left_label_caption = { "", "Manual" },
            right_label_caption = { "", "Circuit Network" },
        }
        local t = frame.add { type = "scroll-pane", name = "scroll" }.add{ 
            type = "table", 
            name = "rabbasca_su_fuel_targets",
            column_count = 4
        }
        frame.scroll.style.maximal_height = 600
        for _, e in pairs(storage.stabilizer.fuel.consumers) do
            if e.entity.valid then
                add_fuel_row(t, e.entity)
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
    local selector = storage.stabilizer.fuel.selector
    frame.rabbasca_su_fuel_signal_switch.switch_state = selector.read_from_network and "right" or "left"
    local current = selector.unfiltered_index
    local fueltable = frame.scroll.rabbasca_su_fuel_targets
    local has_rows = #fueltable.children / 4
    local i = 0
    local index_by_type = { }
    for _, c in pairs(storage.stabilizer.fuel.consumers) do
        if c.entity.valid then
            local e = c.entity
            i = i + 1
            local id = i * 4 - 3
            if i > has_rows then
                add_fuel_row(fueltable, e)
            end
            local inv = e.get_inventory(defines.inventory.burnt_result)
            index_by_type[e.name] = (index_by_type[e.name] or 0) + 1
            fueltable.children[id    ].sprite = "entity/"..e.name
            fueltable.children[id    ].tags   = { name = e.name, index = index_by_type[e.name], full = true }
            fueltable.children[id    ].style  = i == current and "yellow_inventory_slot" or "inventory_slot"
            fueltable.children[id    ].number = e.burner.remaining_burning_fuel / fuel.ENERGY_PER_CELL_MINI
            fueltable.children[id + 1].value  = e.burner.remaining_burning_fuel / fuel.ENERGY_PER_CELL_MINI
            fueltable.children[id + 2].number = inv.get_item_count("rabbasca-warp-cell")
            fueltable.children[id + 3].number = inv.get_item_count("rabbasca-warp-cell-recharging")
            fueltable.children[id + 2].style.size = 32
            fueltable.children[id + 3].style.size = 32
        end
    end
    for j = 4 * (i + 1), #fueltable.children do
        fueltable.children[j].destroy()
    end
    if frame.cam0 then
        local pos = storage.stabilizer.fuel.consumers[current] and storage.stabilizer.fuel.consumers[current].entity.valid and storage.stabilizer.fuel.consumers[current].entity.position or {0, 0}
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
    t.rabbasca_su_autopilot.switch_state = storage.stabilizer.settings.autopilot and "right" or "left"

    if frame.rabbasca_su_content.miners then
        frame.rabbasca_su_content.miners.rabbasca_su_miners_target.slider_value = storage.stabilizer.miners.active_target
        frame.rabbasca_su_content.miners.energy_saved.caption = string.format("%i/%i", #storage.stabilizer.miners.entities, storage.stabilizer.miners.active_target)
    end

    if frame.rabbasca_su_progress then
        frame.rabbasca_su_progress.bar.value = warp.get_repair_progress()
        frame.rabbasca_su_progress.bar.caption = { "rabbasca-extra.panel-progress", string.format("%.1f", warp.get_repair_progress() * 100), storage.stabilizer.anomalies.current }
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