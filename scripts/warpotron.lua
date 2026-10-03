local M = { }

local function filter_matches(network, entity)
    local settings = storage.warpotron_settings and storage.warpotron_settings[entity.unit_number] and storage.warpotron_settings[entity.unit_number].group
    if not settings then return not network end
    if not network then return false end
    return network.get_signal(settings) > 0
end

local function show_failure(e, reason)
    for _, player in pairs(e.force.connected_players) do
        player.create_local_flying_text{ text = { reason }, position = e.position, surface = e.surface }
    end
end

function M.summon_fleet(surface, position, network)
    if not storage.stabilizer then return end
    local fuel_cost = prototypes.entity["rabbasca-ufo"].burner_prototype.initial_fuel.fuel_value / 2
    for _, c in pairs(storage.stabilizer.fuel.consumers) do
        local e = c.entity
        if e.valid and e.name == "rabbasca-ufo" then
            if e.get_driver() then show_failure(e, "rabbasca-extra.ufo-no-warp-has-driver")
            elseif (not e.get_inventory(defines.inventory.spider_trunk).is_empty()) or (not e.get_inventory(defines.inventory.spider_trash).is_empty()) then
                show_failure(e, "rabbasca-extra.ufo-no-warp-full-inventory")
            elseif not filter_matches(network, e) then
                -- show_failure(e, "rabbasca-extra.ufo-no-warp-wrong-control-group")
            elseif e.burner.remaining_burning_fuel <= fuel_cost then
                show_failure(e, "rabbasca-extra.ufo-no-warp-not-enough-fuel")
            else
                e.burner.remaining_burning_fuel = e.burner.remaining_burning_fuel - fuel_cost
                local p = { x = position.x + math.random(-3, 3), y = position.y + math.random(-3, 3) }
                e.teleport(p, surface, false)
            end
        end
    end
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
    M.summon_fleet(event.entity.surface, event.entity.position)
end)

script.on_event(prototypes.recipe["rabbasca-summon-ufo-with-filter-red"].on_crafted_event, function(event)
    M.summon_fleet(event.entity.surface, event.entity.position, event.entity.get_circuit_network(defines.wire_connector_id.circuit_red))
end)

script.on_event(prototypes.recipe["rabbasca-summon-ufo-with-filter-green"].on_crafted_event, function(event)
    M.summon_fleet(event.entity.surface, event.entity.position, event.entity.get_circuit_network(defines.wire_connector_id.circuit_green))
end)

return M