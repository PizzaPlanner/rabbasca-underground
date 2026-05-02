local M = { }

local warp = require("scripts.warp")

local function add_button(parent, sprite, style, name, size)
    local btn = parent.add{
        type = "sprite-button",
        sprite= sprite,
        style = style,
        name = name,
    }
    btn.style.size = size
end

local function create_affinity_bar(player, numbers)
    if numbers and player.gui.top.rabbasca_ug_stats then
        if not player.gui.top.rabbasca_ug_stats.right then return end
        if not storage.stabilizer.anomalies then return end
        player.gui.top.rabbasca_ug_stats.right.repairs.bar.value = warp.get_repair_progress()
        player.gui.top.rabbasca_ug_stats.right.repairs.bar.tooltip = { "A more stable warpfield decreases the cost to warp to the next location and increases the chance of anomalies collapsing into resources in the next location" }
        return
    end
    if player.gui.top.rabbasca_ug_stats then
        player.gui.top.rabbasca_ug_stats.destroy()
    end

    local config = storage.stabilizer.config
    local affinity = storage.stabilizer.current_location
    local chances = warp.get_next_planet_chances()
    local next_tooltip = { "", { "rabbasca-extra.stabilizer-ui-current-location", { "space-location-name."..affinity } } }
    for p, chance in pairs(chances) do
        table.insert(next_tooltip, { "rabbasca-extra.stabilizer-ui-next-location-entry", p, math.floor(chance * 100), config.planets[p].min_stay, config.planets[p].max_stay })
    end

    local frame = player.gui.top.add{
        type = "frame",
        name = "rabbasca_ug_stats",
        direction = "horizontal",
        style = "slot_window_frame",
    }
    frame.style.vertically_stretchable = false
    frame.add{
        type = "sprite-button",
        sprite= affinity and "space-location/"..affinity or "entity/rabbasca-warp-stabilizer",
        style = "inventory_slot",
        name = "rabbasca_ug_current_planet",
        tooltip = next_tooltip
    }
    local right = frame.add {
        type = "flow",
        direction = "vertical",
        name = "right",
    }
    right.style.vertical_spacing = 0

    local repairs = right.add {
        type = "flow",
        direction = "horizontal",
        name = "repairs",
    }
    repairs.style.vertical_align = "center"
    add_button(repairs, "item/rabbasca-warp-cell", "transparent_slot", "icon", 16)
    local bar2 = repairs.add {
        type = "progressbar",
        name = "bar",
        value = 0,
        style = "production_progressbar",
    }
    bar2.style.minimal_width = 64
    bar2.style.natural_width = 64
    bar2.style.horizontal_align = "center"
    bar2.style.horizontally_stretchable = true
    bar2.style.color = { 1, 1, 1 }
end

function M.set_stabilizer_ui(player)
    local frame = player.gui.relative.rabbasca_stabilizer_ui
    if (not storage.stabilizer) or player.opened ~= storage.stabilizer.entity then
        if frame then frame.destroy() end
        return
    end
    local info = { 
        discharge_rate = -storage.stabilizer.charge.drain
    }
    if not frame then
        frame = player.gui.relative.add{
            type = "frame",
            name = "rabbasca_stabilizer_ui",
            caption = "Control Panel",
            direction = "vertical",
            anchor = {
                gui = defines.relative_gui_type.assembling_machine_gui,
                position = defines.relative_gui_position.right
            }
        }
        local subframe = frame.add {
            type = "frame",
            name = "rabbasca_su_content",
            style = "entity_frame",
            direction = "vertical"
        }
        subframe.add {
            type = "label",
            caption = { "", "[img=virtual-signal.signal-alert] Authorized Personnel only!"}
        }
        local f1 = subframe.add { type = "table", name = "rabbasca_su_table", column_count = 3 }
        if player.force.technologies["rabbasca-stabilizer-extractor"].researched then
            f1.add {
                type = "checkbox",
                name = "su_agreement_reboot",
                tooltip = { "", "\"I have read the instructions and am aware that my actions can render the stabilizer useless.\"\n[ [color=yellow]Sign liability agreement with RABBASCORP[/color] ]" },
                state = false
            }
            f1.add {
                type = "label",
                caption = { "", "[entity=rabbasca-stabilizer-consumer] Extractor" },
            }
            f1.add {
                type = "switch",
                name = "rabbasca_su_switch_miner_reboot",
                tooltip = { "", "Requires 5 [item=rabbasca-warp-cell] to boot. When active, discharges [item=rabbasca-warp-cell] at a rate of 2%/s\n[img=virtual-signal.signal-check] Confirm that you read the instructions to proceed" },
                left_label_caption = "",
                right_label_caption = { "", storage.stabilizer.anomaly_recycler and "[color=green]Online[/color]" or "[color=red]Offline[/color]" },
                enabled = false
            }
        end
        f1.add {
            type = "checkbox",
            name = "su_agreement_warp",
            tooltip = { "", "\"I have read the instructions and am aware that my actions can render the stabilizer useless.\"\n[ [color=yellow]Sign liability agreement with RABBASCORP[/color] ]" },
            state = false
        }
        f1.add {
            type = "label",
            caption = { "", "[item=rabbasca-coordinate-system] Warp-drive" }
        }
        f1.add {
            type = "switch",
            name = "rabbasca_su_manual_warp",
            tooltip = { "", "Immediately warp to the next location. Costs [item=rabbasca-warp-cell], depending on stabilization progress.\n[img=virtual-signal.signal-check] Confirm that you read the instructions to proceed" },
            left_label_caption = "",
            right_label_caption = { "", "Warp now" },
            enabled = false
        }
        f1.add {
            type = "checkbox",
            name = "su_agreement_abandon",
            tooltip = { "", "\"I have read the instructions and am aware that my actions can render the stabilizer useless.\"\n[ [color=yellow]Sign liability agreement with RABBASCORP[/color] ]" },
            state = false
        }
        f1.add {
            type = "label",
            caption = { "", "[item=explosives] Kill-switch" }
        }
        f1.add {
            type = "switch",
            name = "rabbasca_su_abandon",
            tooltip = { "", "Initiate self-destruction protocol. The stabilizer and the area surrounding it will be destroyed permanently.\n[img=virtual-signal.signal-check] Confirm that you read the instructions to proceed" },
            switch_state = "left",
            left_label_caption = "",
            right_label_caption = { "", "Lights out" },
            enabled = false
        }
        f1.add { type = "empty-widget" } f1.add { type = "line" } f1.add { type = "line" }
        f1.add { type = "empty-widget" }
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
        if player.force.technologies["rabbasca-total-recall"].researched then
            f1.add { type = "empty-widget" }
            f1.add {
                type = "label",
                caption = { "", "[virtual-signal=rabbasca-warp-inventory] Mass-recall" },
            }
            f1.add {
                type = "switch",
                name = "rabbasca_su_recall",
                left_label_caption = "",
                right_label_caption = { "", "Enabled" }
            }
        end

        local max_safe_radius = 10
            + (player.force.technologies["rabbasca-warp-floor-expansion"].level - 1) * 4
            + (player.force.technologies["rabbasca-permanent-floor-expansion-1"].researched and 4 or 0)
            + (player.force.technologies["rabbasca-permanent-floor-expansion-2"].researched and 4 or 0)
        if storage.stabilizer.safe_zone_setting and max_safe_radius > 10 then
            local safe_zone_frame = subframe.add { type = "flow", direction = "horizontal", name = "rabbasca_su_safe" }
            safe_zone_frame.add { type = "label", caption = {"", "[tile=rabbasca-underground-rubble-powered]"}}
            safe_zone_frame.add { 
                type = "slider",
                name = "rabbasca_su_safe_zone",
                style = "notched_slider",
                minimum_value = 10,
                maximum_value = max_safe_radius,
                value_step = 4,
                value = storage.stabilizer.safe_zone_setting,
                tooltip = { "", "Set the radius of [tile=rabbasca-underground-rubble-powered] around the stabilizer. Discharges [item=rabbasca-warp-cell] at a rate of 0.2% per second per step of 4.\nThis setting only takes effect after warping to a new location." }
            }
            safe_zone_frame.add { 
                type = "label", 
                name = "rabbasca_su_safe_zone_text",
                caption = storage.stabilizer.safe_zone_setting
            }
        end

        frame.add {
            type = "label",
            style = "frame_title",
            caption = { "", "[virtual-signal=signal-info] Dashboard" }
        }
        local fuel_frame = frame.add {
            type = "frame",
            name = "rabbasca_su_fuel",
            style = "entity_frame",
            direction = "vertical"
        }
        fuel_frame.add {
            type = "label",
            name = "rabbasca_su_fuel_left",
        }
        fuel_frame.add {
            type = "label",
            name = "rabbasca_su_repairs",
            tooltip = { "", "After changing location, gains [item=rabbasca-warp-cell] depending on stabilization progress in the previous location" }
        }
        fuel_frame.add {
            type = "label",
            name = "rabbasca_su_cost_fix"
        }
        fuel_frame.add {
            type = "label",
            name = "rabbasca_su_cost_warp"
        }
        fuel_frame.add {
            type = "label",
            caption = { "", string.format("[font=default-bold]%i[/font] warps without incident", storage.stabilizer.finished_warps or 0) }
        }
        fuel_frame.add {
            type = "label",
            -- style = "frame_title",
            name = "rabbasca_su_battery_drain",
        }
    end
    local t = frame.rabbasca_su_content.rabbasca_su_table
    if t.rabbasca_su_switch_miner_reboot then
        t.rabbasca_su_switch_miner_reboot.enabled = t.su_agreement_reboot.state
        t.rabbasca_su_switch_miner_reboot.switch_state = storage.stabilizer.anomaly_recycler and "right" or "left"
    end
    t.rabbasca_su_manual_warp.enabled = t.su_agreement_warp.state
    t.rabbasca_su_manual_warp.switch_state = storage.stabilizer.warping and "right" or "left"
    t.rabbasca_su_abandon.enabled = t.su_agreement_abandon.state

    t.rabbasca_su_autopilot.switch_state = storage.stabilizer.settings.autopilot and "right" or "left"

    if t.rabbasca_su_recall then
        t.rabbasca_su_recall.switch_state = storage.stabilizer.settings.recall and "right" or "left"
    end

    if frame.rabbasca_su_content.rabbasca_su_safe then
        frame.rabbasca_su_content.rabbasca_su_safe.rabbasca_su_safe_zone.slider_value = storage.stabilizer.safe_zone_setting
        frame.rabbasca_su_content.rabbasca_su_safe.rabbasca_su_safe_zone_text.caption = tostring(storage.stabilizer.safe_zone_setting)
    end

    frame.rabbasca_su_fuel.rabbasca_su_fuel_left.caption = { "", string.format("[item=rabbasca-warp-matrix]Anomalies left: %i", storage.stabilizer.anomalies.current) }
    frame.rabbasca_su_fuel.rabbasca_su_repairs.caption =   { "", string.format("Stabilization:  %i%%", warp.get_repair_progress() * 100) }
    frame.rabbasca_su_fuel.rabbasca_su_cost_fix.caption =   { "", string.format("[recipe=rabbasca-stabilize-warpfield]: %.2f%%[item=rabbasca-warp-cell]/s", 1 * (1 + storage.stabilizer.entity.effects.consumption)) }
    frame.rabbasca_su_fuel.rabbasca_su_cost_warp.caption =   { "", string.format("[recipe=rabbasca-stabilizer-warp-sequence]: %.2f%%[item=rabbasca-warp-cell]/s", warp.get_warp_cost() * (1 + storage.stabilizer.entity.effects.consumption)) }
    frame.rabbasca_su_fuel.rabbasca_su_battery_drain.caption = { "", string.format("Current: %s%.2f%%[item=rabbasca-warp-cell]/s", info.discharge_rate > 0 and "+" or "", info.discharge_rate) }
end

function M.update_affinity_bar(player, numbers)
    local is_on_rabbasca = player.surface and player.surface.name == "rabbasca-underground"
    local ui = player.gui.top.rabbasca_ug_stats
    if ui and not is_on_rabbasca then
        ui.destroy()
        local ui_legacy = player.gui.top.rabbasca_affinity
        if ui_legacy then ui_legacy.destroy() end
    elseif is_on_rabbasca then
        create_affinity_bar(player, numbers)
    end
end

return M