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
        local surface = game.surfaces[storage.stabilizer.surface]
        local dump = surface and surface.find_entities_filtered({name = "rabbasca-anomaly-storage"})
        if #dump == 0 then
            storage.stabilizer.miners.chest = surface and surface.create_entity{ position = {0, 6}, name = "rabbasca-anomaly-storage", force = storage.stabilizer.entity.force }
        else
            storage.stabilizer.miners.chest = dump[1]
        end
    end
    for i, e in pairs(storage.stabilizer.miners.entities) do
        if not e.miner.valid then
            if e.chest.valid then e.chest.destroy { } end
            storage.stabilizer.miners.entities[i] = nil
        elseif storage.stabilizer.warping then
            e.miner.teleport({0, -1})
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
end

return M