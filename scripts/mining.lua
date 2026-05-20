local fuel = require("scripts.fuel")
local M = { }

function M.on_add_miner()
    storage.stabilizer.miners.available = storage.stabilizer.miners.available + 1
end

function M.on_mining_update()
    if not storage.stabilizer.miners then return end
    local deployed = 0
    local deploy_target = storage.stabilizer.miners.active_target
    local mine_target = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_trash)
    for i, e in pairs(storage.stabilizer.miners.entities) do
        if not e.valid then
            table.remove(storage.stabilizer.miners.entities, i)
        elseif deployed >= deploy_target then
            local chest = e.surface.find_entity("rabbasca-miner-remote", e.position)
            if chest then
                chest.destroy { }
            end
            fuel.rescue_cell(e)
            e.mine { inventory = mine_target, ignore_minable = true }
        else
            deployed = deployed + 1
            if storage.stabilizer.warping then
                local chest = e.surface.find_entity("rabbasca-miner-remote", e.position)
                e.teleport(storage.stabilizer.entity.position)
                chest.teleport(storage.stabilizer.entity.position)
                e.update_connections()
            elseif not (e.mining_target and e.mining_target.valid) then
                local chest = e.surface.find_entity("rabbasca-miner-remote", e.position)
                for _, next in pairs(storage.stabilizer.anomalies.entities) do
                    if next.valid and not next.surface.find_entity("rabbasca-collector-pylon",next.position) then
                        e.teleport(next.position)
                        chest.teleport(next.position)
                        e.update_connections()
                        goto continue
                    end
                end
            end
            ::continue::
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
                        fuel.register_consumer(m)
                        return
                    end
                    c.destroy { }
                end
            end
        end
    end
end

return M