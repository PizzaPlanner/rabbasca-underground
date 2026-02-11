local M = { }

local function stabilizer_config()
    return prototypes.mod_data["rabbasca-stabilizer-config"].data
end

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
    if numbers ~= nil and player.gui.top.rabbasca_ug_stats then
        if not player.gui.top.rabbasca_ug_stats.right then return end
        local fuel_initial = (storage.stabilizer.anomalies and storage.stabilizer.anomalies.initial or 1)
        local fuel_ratio = numbers.fuel / fuel_initial
        -- local is_fuel_critical = fuel_ratio < 0.5 and fuel_ratio < numbers.progress_ratio
        -- player.gui.top.rabbasca_ug_stats.current_planet.number = numbers.progress
        player.gui.top.rabbasca_ug_stats.right.anomalies.bar.value = fuel_ratio
        player.gui.top.rabbasca_ug_stats.right.anomalies.bar.tooltip = { "", numbers.fuel, "/", fuel_initial }
        player.gui.top.rabbasca_ug_stats.right.repairs.bar.value = numbers.progress_ratio or 0
        player.gui.top.rabbasca_ug_stats.right.repairs.bar.tooltip = { "", numbers.progress, "/", numbers.progress_max }
        player.gui.top.rabbasca_ug_stats.right.repairs.bar.caption = { "", numbers.progress }
        return
    end
    if player.gui.top.rabbasca_ug_stats then
        player.gui.top.rabbasca_ug_stats.destroy()
    end
    if not settings.get_player_settings(player)["rabbasca-show-alertness-ui"].value then return end

    local config = stabilizer_config()
    local affinity = storage.stabilizer.current_location
    local chances = M.get_next_planet_chances()
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
        name = "current_planet",
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
    add_button(repairs, "item/rabbasca-stabilize-warpfield", "transparent_slot", "icon", 16)
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

    local anoms = right.add {
        type = "flow",
        direction = "horizontal",
        name = "anomalies",
    }
    anoms.style.vertical_align = "center"
    add_button(anoms, "entity/rabbasca-warp-anomaly", "transparent_slot", "icon", 16)
    local bar = anoms.add {
        type = "progressbar",
        name = "bar",
        value = 1,
    }
    bar.style.minimal_width = 64
    bar.style.natural_width = 64
    bar.style.horizontally_stretchable = true
    bar.style.color = { 0.15, 0.4, 0.85 }
    bar.style.horizontal_align = "center"
    bar.style.font = "default-tiny-bold"

    frame.add {
        type = "sprite-button",
        sprite = "virtual-signal/signal-trash-bin",
        style = "side_menu_button",
        name = "rabbasca_abandon_stabilizer",
        tooltip = { "rabbasca-extra.abandon-stabilizer" },
    }
    
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