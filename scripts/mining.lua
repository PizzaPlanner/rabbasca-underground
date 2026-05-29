local fuel = require("scripts.fuel")
local M = { }

function M.on_add_miner(e)
    local chest = e.surface.create_entity {
        name = "rabbasca-miner-remote",
        position = e.position,
        force = storage.stabilizer.entity.force
    }
    chest.proxy_target_inventory = defines.inventory.chest
    chest.proxy_target_entity = storage.stabilizer.miners.chest
    storage.stabilizer.miners.entities[e.unit_number] = { miner  = e, chest = chest }
    e.destructible = false
    chest.destructible = false
end


function M.on_mining_update()
    if not storage.stabilizer.miners then return end
    if not (storage.stabilizer.miners.chest and storage.stabilizer.miners.chest.valid) then
        local dump = storage.stabilizer.entity.surface.find_entities_filtered({name = "rabbasca-fuel-remote-big"})
        if #dump == 0 then
            storage.stabilizer.miners.chest = storage.stabilizer.entity.create_entity{ surface = storage.stabilizer.surface, position = {0, 6}, name = "rabbasca-fuel-remote-big"}
        else
            storage.stabilizer.miners.chest = dump[1]
        end
    end
    for i, e in pairs(storage.stabilizer.miners.entities) do
        if not e.miner.valid then
            if e.chest.valid then e.chest.destroy { } end
            storage.stabilizer.miners.entities[i] = nil
        elseif storage.stabilizer.warping then
            e.miner.teleport({0, 0})
        elseif not (e.miner.mining_target and e.miner.mining_target.valid) then
            for _, anom in pairs(storage.stabilizer.anomalies.entities) do
                if anom.valid and not anom.surface.find_entity("rabbasca-collector-pylon", anom.position) then
                    e.miner.teleport(anom.position)
                    e.chest.teleport(anom.position)
                    break
                end
            end
        elseif not (e.chest.valid and e.chest.proxy_target_entity and e.chest.proxy_target_entity.valid) then
            if e.chest.valid then e.chest.destroy { } end
            M.on_add_miner(e.miner)
        end
    end
    local dump_inv = storage.stabilizer.miners.chest.get_inventory(defines.inventory.chest)
    if dump_inv.remove({name = "rabbasca-collector-pylon", count = 1}) > 0 then
        storage.stabilizer.miners.chest.surface.create_entity { 
            name = "rabbasca-collector-pylon",
            position = {0, 0},
            force = storage.stabilizer.miners.chest.force
        }
    end
end

return M