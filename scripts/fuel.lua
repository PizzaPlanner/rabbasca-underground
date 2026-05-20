local M = { 
    ENERGY_PER_CELL      = prototypes.item["rabbasca-warp-cell"].fuel_value,
    ENERGY_PER_CELL_MINI = 50000000
}

function M.set_target(tags)
    storage.stabilizer.fuel.selector = {
        read_from_network = false,
        filter = tags.name and { [tags.name] = tags.index or 1 } or { },
        filter2 = { full = 0, empty = 0, missing = 0 },
        index = tags.index or 1,
        unfiltered_index = 0
    }
end

function M.attempt_cell_recharge(inventory_owner, auto_refuel)
    if not (inventory_owner and inventory_owner.valid) then return end
    local inventories_from = { defines.inventory.burnt_result, defines.inventory.chest }
    for _, idx in pairs(inventories_from) do
        local inv = inventory_owner.get_inventory(idx)
        local cells = inv and inv.get_item_count("rabbasca-warp-cell-recharging") or 0
        if cells > 0 then
            local pity_per = 0.001 + 0.00075 / cells
            for i = 1,#inv do
                if inv[i].valid_for_read and inv[i].name == "rabbasca-warp-cell-recharging" then
                    local current = (inv[i].tags.chance or 0)
                    if math.random() <= current and inv[i].set_stack({name = "rabbasca-warp-cell", count = 1, quality = inv[i].quality, spoil_percent = 0 }) then
                        local fuel = auto_refuel and idx ~= defines.inventory.fuel and inventory_owner.get_inventory(defines.inventory.fuel)
                        if fuel and fuel.insert(inv[i]) > 0 then inv[i].clear() end
                    else
                        inv[i].tags = { chance = current + pity_per }
                        inv[i].spoil_percent = math.min(inv[i].spoil_percent, 0.9 - (inv[i].tags.chance * 5))
                        inv[i].custom_description = { "", { "item-description.rabbasca-warp-cell-recharging-tags", string.format("%.1f", inv[i].tags.chance * 100) }, { "item-description.rabbasca-warp-cell-recharging" } }
                    end
                end
            end
        end
    end
end

function M.recharge_consumers()
    local new_fuel = 0
    local inv  = storage.stabilizer.entity.get_inventory(defines.inventory.burnt_result)
    for i = 1, #inv do
        local full = 1 - (inv[i].valid_for_read and inv[i].name == "rabbasca-warp-cell" and inv[i].spoil_percent or 1)
        new_fuel = new_fuel + full
    end
    new_fuel = new_fuel * M.ENERGY_PER_CELL / 60
    local available = new_fuel
    local total_demand = 0
    for i, c in pairs(storage.stabilizer.fuel.consumers) do
        if c.entity.valid then
            local e = c.entity
            local required_watts = e.burner.heat_capacity / 1.065 -- Why weird magic number???
            local demand = M.ENERGY_PER_CELL_MINI - e.burner.remaining_burning_fuel
            total_demand = total_demand + required_watts
            local missing = math.min(available, demand)
            if missing > 0 then
                e.burner.remaining_burning_fuel = e.burner.remaining_burning_fuel + missing
                available = available - missing
            end
        end
    end
    storage.stabilizer.fuel.load = { available = new_fuel, demand = total_demand }
end

function M.recharge_consumers_alt()
    for _, e in pairs(storage.stabilizer.fuel.consumers) do
        if e.entity.valid then
            local new_fuel = 0
            local cell  = e.cell
            if cell.valid_for_read and cell.name == "rabbasca-warp-cell" then
                local full = 1 - (cell.spoil_percent or 1)
                new_fuel = new_fuel + full
            end
            local burner = e.entity.burner
            -- if (not burner.currently_burning) or (burner.currently_burning.name ~= "rabbasca-warp-cell-internal") then
            --     burner.currently_burning = "rabbasca-warp-cell-internal"
            -- end -- currently_burning will not reset when fuel_inventory == 0
            burner.remaining_burning_fuel = burner.remaining_burning_fuel + new_fuel * M.ENERGY_PER_CELL / 20
        end
    end
end

function M.on_consumer_died(id)
    if storage.stabilizer and storage.stabilizer.fuel.consumers then
        storage.stabilizer.fuel.consumers[id] = nil
    end
end

function M.register_consumer(e)
    local inv = e.get_inventory(defines.inventory.burnt_result)
    local id, _, _ = script.register_on_object_destroyed(e)
    if not (inv and #inv > 0) then return end
    storage.stabilizer.fuel.consumers[id] = { entity = e, inventory = inv, cell = inv[1] }
    if e.burner.currently_burning == nil then
        e.burner.currently_burning = "rabbasca-warp-cell-internal"
    end
    game.print("Registered fuel consumer: "..e.gps_tag..", now have "..table_size(storage.stabilizer.fuel.consumers))
end

function M.rescue_cell(e)
    if e.valid and e.burner and e.burner.remaining_burning_fuel > 0 then
        e.burner.currently_burning = nil
        e.get_inventory(defines.inventory.burnt_result).insert({name = "rabbasca-warp-cell-recharging", amount = 1})
    end
end
return M