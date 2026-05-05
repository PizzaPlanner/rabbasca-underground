local M = { }

local warp = require("scripts.warp")

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

function M.set_stabilizer_ui(player)
    local frame = player.gui.relative.rabbasca_stabilizer_ui
    if (not storage.stabilizer) or player.opened ~= storage.stabilizer.entity then
        if frame then frame.destroy() end
        return
    end
    local recipe = storage.stabilizer.entity.get_recipe()
    local is_rebooting = recipe and recipe.name == "rabbasca-reboot-stabilizer"
    local info = { 
        discharge_rate = -storage.stabilizer.charge.drain
    }
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

        if storage.stabilizer.entity.force.technologies["rabbasca-stabilizer-relichunter"].researched then
            local bar = frame.add {
                type = "label",
                name = "relichunter_progress",
            }
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

        f1.add { type = "label", caption = { "", "[item=rabbasca-stabilizer-warp-sequence]" } }
        if storage.stabilizer.entity.force.technologies["rabbasca-stabilizer-warpdrive"].researched then
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
            if is_booted then
                add_button(f2, "virtual-signal/signal-anticlockwise-circle-arrow", "side_menu_button", "rabbasca_su_btn_repair_warpdrive", 20)
            end
        end

        f1.add { type = "label", caption = { "", "[entity=rabbasca-anomaly-extractor]" } }
        if storage.stabilizer.entity.force.technologies["rabbasca-stabilizer-extractor"].researched then
            f1.add {
                type = "label",
                name = "rabbasca_su_status_extractor",
            }
        else
            local f2 = f1.add { type = "flow" }
            f2.add {
                type = "label",
                caption = { "", "[color=red]OFFLINE[/color]" }
            }
            if is_booted then
                add_button(f2, "virtual-signal/signal-anticlockwise-circle-arrow", "side_menu_button", "rabbasca_su_btn_repair_extractor", 20)
            end
        end

        f1.add { type = "label", caption = { "", "[virtual-signal=signal-map-marker]" } }
        if storage.stabilizer.entity.force.technologies["rabbasca-stabilizer-relichunter"].researched then
            f1.add {
                type = "label",
                name = "rabbasca_su_status_relichunter",
            }
        else
            local f2 = f1.add { type = "flow" }
            f2.add {
                type = "label",
                caption = { "", "[color=red]OFFLINE[/color]" }
            }
            if is_booted then
                add_button(f2, "virtual-signal/signal-anticlockwise-circle-arrow", "side_menu_button", "rabbasca_su_btn_repair_relichunter", 20)
            end
        end

        f1.add { type = "line" } f1.add { type = "line" }

        -- Settings
        f1.add {
            type = "label",
            caption = { "", "[item=rabbasca-warp-cell] Synthesize fuel" },
        }
        f1.add {
            type = "switch",
            name = "rabbasca_su_autofuel",
            left_label_caption = "",
            right_label_caption = { "", "Enabled" }
        }
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
        else
            f1.add {
                type = "label",
                caption = { "", "[Not researched]" },
            }
            f1.add {
                type = "switch",
                enabled = false,
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
                tooltip = { "rabbasca-extra.panel-setting-radius", storage.stabilizer.settings.safe_zone_upkeep_per_radius * 4 }
            }
            safe_zone_frame.add { 
                type = "label", 
                name = "rabbasca_su_safe_zone_text",
                caption = storage.stabilizer.safe_zone_setting
            }
        end

        -- Recipes
        local subframe = frame.add {
            type = "frame",
            name = "rabbasca_su_fuelcosts",
            style = "entity_frame",
            direction = "vertical"
        }
        subframe.add { type = "label", name = "upkeep" }
        subframe.add { type = "label", name = "tank" }
        local f1 = subframe.add { type = "flow", name = "table" }
        f1.style.horizontal_spacing = 0
        local b = add_button(f1, "recipe/rabbasca-stabilize-warpfield", "slot_button", "stabilize", 36)
        b.show_percent_for_small_numbers = true
        b = add_button(f1, "recipe/rabbasca-stabilizer-warp-sequence", "slot_button", "warp", 36)
        b.show_percent_for_small_numbers = true
        b = add_button(f1, "recipe/rabbasca-stabilizer-toggle-extractor", "slot_button", "toggle_extractor", 36)
        b.show_percent_for_small_numbers = true
        b = add_button(f1, "recipe/rabbasca-stabilizer-toggle-relichunter", "slot_button", "toggle_relichunter", 36)
        b.show_percent_for_small_numbers = true

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
    t.rabbasca_su_autofuel.switch_state = storage.stabilizer.settings.autofuel   and "right" or "left"

    if t.rabbasca_su_recall then
        t.rabbasca_su_recall.switch_state = storage.stabilizer.settings.recall and "right" or "left"
    end

    if frame.rabbasca_su_content.rabbasca_su_safe then
        frame.rabbasca_su_content.rabbasca_su_safe.rabbasca_su_safe_zone.slider_value = storage.stabilizer.safe_zone_setting
        frame.rabbasca_su_content.rabbasca_su_safe.rabbasca_su_safe_zone_text.caption = tostring(storage.stabilizer.safe_zone_setting)
    end

    if frame.rabbasca_su_fuelcosts then
        local config = storage.stabilizer.config.recipe_settings
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

    -- frame.rabbasca_su_fuel.rabbasca_su_fuel_left.caption = { "", string.format("[item=rabbasca-warp-matrix]Anomalies left: %i", storage.stabilizer.anomalies.current) }
    -- frame.rabbasca_su_fuel.rabbasca_su_repairs.caption =   { "", string.format("Stabilization:  %i%%", warp.get_repair_progress() * 100) }
    -- frame.rabbasca_su_fuel.rabbasca_su_cost_fix.caption =   { "", string.format("[recipe=rabbasca-stabilize-warpfield]: %.2f%%[item=rabbasca-warp-cell]/s", 1 * warp.get_fuel_time_modifier()) }
    -- frame.rabbasca_su_fuel.rabbasca_su_cost_warp.caption =   { "", string.format("[recipe=rabbasca-stabilizer-warp-sequence]: %.2f%%[item=rabbasca-warp-cell]/s", warp.get_warp_cost() * warp.get_fuel_time_modifier()) }
    -- frame.rabbasca_su_fuel.rabbasca_su_battery_drain.caption = { "", string.format("Current: %s%.2f%%[item=rabbasca-warp-cell]/s", info.discharge_rate > 0 and "+" or "", info.discharge_rate) }
end

return M