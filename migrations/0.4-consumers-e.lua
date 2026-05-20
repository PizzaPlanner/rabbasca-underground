if storage.stabilizer and storage.stabilizer.fuel.consumers then
local new_consumers = { }
for i, c in pairs(storage.stabilizer.fuel.consumers) do
    if c.valid then
        local inv = c.get_inventory(defines.inventory.burnt_result)
        if inv and #inv > 0 then
            table.insert(new_consumers, { entity = c, inventory = inv, cell = inv[1]})
        end
    end
end
storage.stabilizer.fuel.consumers = new_consumers
game.print("[Rabbasca underground DEBUG] Migrated consumers")
end