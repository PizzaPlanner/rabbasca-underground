local M = { }

function M.on_add_miner()
    storage.stabilizer.miners.available = storage.stabilizer.miners.available + 1
end

function M.on_mining_update()
    if not storage.stabilizer.miners then return end
    local deployed = 0
    local deploy_target = (storage.stabilizer.warping and 0 or storage.stabilizer.miners.active_target)
    local mine_target = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_trash)
    for i, e in pairs(storage.stabilizer.miners.entities) do
        if not e.valid then
            table.remove(storage.stabilizer.miners.entities, i)
        elseif deployed >= deploy_target or not (e.mining_target and e.mining_target.valid) then
            local chest = e.surface.find_entity("rabbasca-miner-remote", e.position)
            if chest then
                chest.destroy { }
            end
            storage.stabilizer.miners.saved_fuel = (storage.stabilizer.miners.saved_fuel or 0) + e.burner.remaining_burning_fuel
            e.mine { inventory = mine_target, ignore_minable = true }
        else
            deployed = deployed + 1
        end
    end
    if game.tick - 120 < storage.stabilizer.miners.last_deployment then return end
    if deployed < math.min(storage.stabilizer.miners.available, deploy_target) then
        for _, e in pairs(storage.stabilizer.anomalies.entities) do
            if e.valid and not e.surface.find_entity("rabbasca-collector-pylon",e.position) then
                local c = e.surface.create_entity {
                    name = "rabbasca-miner-remote",
                    position = e.position,
                    force = storage.stabilizer.entity.force
                }
                if c then
                    c.proxy_target_inventory = defines.inventory.crafter_trash
                    c.proxy_target_entity = storage.stabilizer.entity
                    local m = e.surface.create_entity{
                        name = "rabbasca-collector-pylon",
                        position = e.position,
                        force = storage.stabilizer.entity.force
                    }
                    if m then
                        storage.stabilizer.miners.last_deployment = game.tick
                        table.insert(storage.stabilizer.miners.entities, m)
                        local fuel_stored = storage.stabilizer.miners.saved_fuel or 0
                        if fuel_stored > 0 then
                            m.burner.currently_burning = "rabbasca-warp-cell"
                            m.burner.remaining_burning_fuel = fuel_stored
                            storage.stabilizer.miners.saved_fuel = fuel_stored - m.burner.remaining_burning_fuel
                        end
                        table.insert(storage.stabilizer.fuel.consumers, m)
                        return
                    end
                    c.destroy { }
                end
            end
        end
    end
end

return M