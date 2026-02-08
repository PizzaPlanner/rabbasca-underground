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
        player.gui.top.rabbasca_ug_stats.current_planet.number = numbers.progress
        local bar = player.gui.top.rabbasca_ug_stats.right.fuel.bar
        bar.caption = { "", "[item=rabbasca-warp-matrix]", tostring(numbers.fuel), "/", tostring(numbers.progress) }
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
    frame.add {
        type = "sprite-button",
        sprite = "virtual-signal/signal-trash-bin",
        style = "side_menu_button",
        name = "rabbasca_abandon_stabilizer",
        tooltip = { "rabbasca-extra.abandon-stabilizer" }
    }
    local top = right.add {
        type = "flow",
        direction = "horizontal",
        name = "top",
    }
    top.style.vertical_align = "center"
    add_button(top, "virtual-signal/signal-map-marker", "transparent_slot", "resources_marker", 16)
    local recipes1 = top.add {
        type = "flow",
        direction = "horizontal",
        name = "resources",
    }
    recipes1.style.horizontal_spacing = 0
    recipes1.style.vertical_align = "center"
    local fuel = right.add {
        type = "flow",
        direction = "horizontal",
        name = "fuel",
    }
    fuel.style.vertical_align = "center"
    -- add_button(fuel, "fluid/harene", "transparent_slot", "icon", 16)
    fuel.add {
        type = "label",
        name = "bar",
        caption = { "", "[item=rabbasca-warp-matrix]", numbers and numbers.fuel or "Calculating..." }
    }
    right.style.top_padding = 1
    local config = config.planets[affinity]
    if config then
        if config.fluid then
            add_button(recipes1, "fluid/"..config.fluid, "inventory_slot", "fluid", 24)
        end
        local i = 0
        for e, _ in pairs(config.autoplace_entities) do
            i = i + 1
            add_button(recipes1, "entity/"..e, "inventory_slot", "icon_"..tostring(i), 24)
        end
        local tech = player.force.technologies["rabbasca-warp-anchoring-"..affinity]
        if tech then
            for _, reward in pairs(tech.prototype.effects) do
                if reward.recipe then
                    i = i + 1
                    add_button(recipes1, "recipe/"..reward.recipe, "inventory_slot", "icon_"..tostring(i), 24)
                end
            end
        end
    end
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