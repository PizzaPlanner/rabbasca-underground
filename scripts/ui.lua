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
        -- player.gui.top.rabbasca_ug_stats.current_planet.number = numbers.progress
        local bar = player.gui.top.rabbasca_ug_stats.bar
        bar.caption = { "", "[item=rabbasca-warp-matrix] ", tostring(numbers.fuel), "\n", "[item=rabbasca-stabilize-warpfield] ", tostring(numbers.progress) }

        storage.stabilizer.map_tag = storage.stabilizer.map_tag or player.force.add_chart_tag(storage.stabilizer.surface, { position = { -150, -150 }, text = "  "})
        storage.stabilizer.map_tag.text = string.format("[item=rabbasca-warp-matrix] %i\n[item=rabbasca-stabilize-warpfield] %i", numbers.fuel, numbers.progress)
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
    local label = frame.add {
        type = "label",
        name = "bar",
        caption = { "", "[item=rabbasca-warp-matrix] [...]" }
    }
    label.style.font = "default-semibold"
    frame.add {
        type = "sprite-button",
        sprite = "virtual-signal/signal-trash-bin",
        style = "side_menu_button",
        name = "rabbasca_abandon_stabilizer",
        tooltip = { "rabbasca-extra.abandon-stabilizer" }
    }
    -- create_affinity_bar(player, true)
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