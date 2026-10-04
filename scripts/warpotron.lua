local eventhandler = require("event_handler")

local M = { }

local function filter_matches(network, entity)
    local settings = storage.warpotron_settings and storage.warpotron_settings[entity.unit_number] and storage.warpotron_settings[entity.unit_number].group
    if not settings then return not network end
    if not network then return false end
    return network.get_signal(settings) > 0
end

local function print_result(results, e)
    local text = { "rabbasca-extra.warp-ufo-no-stabilizer" }
    if results then 
        text = { "", { "rabbasca-extra.warp-ufo-success", results.success or 0 } }
        if (results.driver or 0) > 0 then
            table.insert(text, { "rabbasca-extra.warp-ufo-driver", results.driver })
        end
        if (results.inventory or 0) > 0 then
            table.insert(text, { "rabbasca-extra.warp-ufo-inventory", results.inventory })
        end
        if (results.fuel or 0) > 0 then
            table.insert(text, { "rabbasca-extra.warp-ufo-fuel", results.fuel })
        end
        if (results.filter or 0) > 0 then
            table.insert(text, { "rabbasca-extra.warp-ufo-filter", results.filter })
        end
    end
    for _, player in pairs(e.force.connected_players) do
        player.create_local_flying_text{ text = text, position = e.position, surface = e.surface }
    end
end

local FUEL_COST = prototypes.entity["rabbasca-ufo"].burner_prototype.initial_fuel.fuel_value / 2
function M.summon_fleet(surface, position, network)
    
    local result = { success = 0, driver = 0, inventory = 0, fuel = 0, filter = 0 }
    for _, c in pairs(storage.warpotron_settings or { }) do
        local e = c.entity
        if e and e.valid then
            if not filter_matches(network, e) then
                result.filter = result.filter + 1
            elseif e.get_driver() then
                result.driver = result.driver + 1
            elseif (not e.get_inventory(defines.inventory.spider_trunk).is_empty()) or (not e.get_inventory(defines.inventory.spider_trash).is_empty()) then
                result.inventory = result.inventory + 1
            elseif e.burner.remaining_burning_fuel <= FUEL_COST then
                result.fuel = result.fuel + 1
            else
                result.success = result.success + 1
                e.burner.remaining_burning_fuel = e.burner.remaining_burning_fuel - FUEL_COST
                local p = { x = position.x + math.random(-3, 3), y = position.y + math.random(-3, 3) }
                e.teleport(p, surface, false)
            end
        end
    end
    return result
end

function M.on_cleanup(id)
    storage.warpotron_settings = storage.warpotron_settings or { }
    storage.warpotron_settings[id] = nil
end

function M.register_warpotron(entity)
    storage.warpotron_settings = storage.warpotron_settings or { }
    storage.warpotron_settings[entity.unit_number] = storage.warpotron_settings[entity.unit_number] or { }
    storage.warpotron_settings[entity.unit_number].entity = entity
    script.register_on_object_destroyed(entity)
end

function M.get_warpotrons()
    local result = { }
    for _, c in pairs(storage.warpotron_settings or { }) do
        local e = c.entity
        if e and e.valid then
            table.insert(result, e)
        end
    end
    return result
end

local function on_summon_crafted(event)
    local e = event.entity or (event.player_index and game.players[event.player_index].character)
    if e and e.valid then
        local result = M.summon_fleet(e.surface, e.position, event.network)
        print_result(result, e)
    end
end

local function on_summon_crafted_filtered(event)
    if event.recipe.name == "rabbasca-summon-ufo-with-filter-red" then
        event.network = event.entity.get_circuit_network(defines.wire_connector_id.circuit_red)
    elseif event.recipe.name == "rabbasca-summon-ufo-with-filter-green" then
        event.network = event.entity.get_circuit_network(defines.wire_connector_id.circuit_green)
    end
    on_summon_crafted(event)
end

local function on_summon_handcrafted(event)
    if event.recipe.name ~= "rabbasca-summon-ufo" then return end
    on_summon_crafted(event)
end

local function on_change_filter(event)
    if event.element.name ~= "rabbasca_warpotron_group_selector" then return end
    local player = game.players[event.player_index]
    if not player then return end
    if player.opened and player.opened.name == "rabbasca-ufo" then
        storage.warpotron_settings = storage.warpotron_settings or { }
        storage.warpotron_settings[player.opened.unit_number] = storage.warpotron_settings[player.opened.unit_number] or { }
        storage.warpotron_settings[player.opened.unit_number].group = event.element.elem_value
    end
end

eventhandler.add_lib({
    events = {
        [defines.events.on_player_crafted_item] = on_summon_handcrafted,
        [prototypes.recipe["rabbasca-summon-ufo"].on_crafted_event] = on_summon_crafted,
        [prototypes.recipe["rabbasca-summon-ufo-with-filter-red"].on_crafted_event] = on_summon_crafted_filtered,
        [prototypes.recipe["rabbasca-summon-ufo-with-filter-green"].on_crafted_event] = on_summon_crafted_filtered,
        [defines.events.on_gui_elem_changed] = on_change_filter,
    }
})

return M