local M = { }

local function filter_matches(network, entity)
    local settings = storage.warpotron_settings and storage.warpotron_settings[entity.unit_number] and storage.warpotron_settings[entity.unit_number].group
    if not settings then return not network end
    if not network then return false end
    return network.get_signal(settings) > 0
end

local function print_result(results, e)
    local text = { "", { "rabbasca-extra.warp-ufo-success", results.success } }
    if results.driver > 0 then
        table.insert(text, { "rabbasca-extra.warp-ufo-driver", results.driver })
    end
    if results.inventory > 0 then
        table.insert(text, { "rabbasca-extra.warp-ufo-inventory", results.inventory })
    end
    if results.fuel > 0 then
        table.insert(text, { "rabbasca-extra.warp-ufo-fuel", results.fuel })
    end
    if results.filter > 0 then
        table.insert(text, { "rabbasca-extra.warp-ufo-filter", results.filter })
    end
    for _, player in pairs(e.force.connected_players) do
        player.create_local_flying_text{ text = text, position = e.position, surface = e.surface }
    end
end

function M.summon_fleet(surface, position, network)
    if not storage.stabilizer then return end
    local fuel_cost = prototypes.entity["rabbasca-ufo"].burner_prototype.initial_fuel.fuel_value / 2
    local result = { success = 0, driver = 0, inventory = 0, fuel = 0, filter = 0 }
    for _, c in pairs(storage.stabilizer.fuel.consumers) do
        local e = c.entity
        if e.valid and e.name == "rabbasca-ufo" then
            if not filter_matches(network, e) then
                result.filter = result.filter + 1
            elseif e.get_driver() then
                result.driver = result.driver + 1
            elseif (not e.get_inventory(defines.inventory.spider_trunk).is_empty()) or (not e.get_inventory(defines.inventory.spider_trash).is_empty()) then
                result.inventory = result.inventory + 1
            elseif e.burner.remaining_burning_fuel <= fuel_cost then
                result.fuel = result.fuel + 1
            else
                result.success = result.success + 1
                e.burner.remaining_burning_fuel = e.burner.remaining_burning_fuel - fuel_cost
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

script.on_event(defines.events.on_gui_elem_changed, function(event)
  if event.element.name ~= "rabbasca_warpotron_group_selector" then return end
  local player = game.players[event.player_index]
  if not player then return end
  if player.opened and player.opened.name == "rabbasca-ufo" then
    storage.warpotron_settings = storage.warpotron_settings or { }
    storage.warpotron_settings[player.opened.unit_number] = storage.warpotron_settings[player.opened.unit_number] or { }
    storage.warpotron_settings[player.opened.unit_number].group = event.element.elem_value
  end
end)

script.on_event(prototypes.recipe["rabbasca-summon-ufo"].on_crafted_event, function(event)
    local result = M.summon_fleet(event.entity.surface, event.entity.position)
    print_result(result, event.entity)
end)

script.on_event(prototypes.recipe["rabbasca-summon-ufo-with-filter-red"].on_crafted_event, function(event)
    local result = M.summon_fleet(event.entity.surface, event.entity.position, event.entity.get_circuit_network(defines.wire_connector_id.circuit_red))
    print_result(result, event.entity)
end)

script.on_event(prototypes.recipe["rabbasca-summon-ufo-with-filter-green"].on_crafted_event, function(event)
    local result = M.summon_fleet(event.entity.surface, event.entity.position, event.entity.get_circuit_network(defines.wire_connector_id.circuit_green))
    print_result(result, event.entity)
end)

return M