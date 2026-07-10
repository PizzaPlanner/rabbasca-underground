local M = { 
    ENERGY_PER_CELL      = prototypes.item["rabbasca-warp-cell"].fuel_value,
    ENERGY_PER_STAB_CELL = prototypes.item["rabbasca-warp-cell-internal-big"].fuel_value,
}

function M.tether(item, target)
    local stack = item.item_stack
    if not stack then return end
    local burner = target and target.valid and target.burner
    if not burner then return end
    local cell_name = prototypes.item["rabbasca-warp-cell-indicator-"..target.name] and "rabbasca-warp-cell-indicator-"..target.name or "rabbasca-warp-cell"
    local new_cell = { name = cell_name, count = 1, quality = item.quality, spoil_percent = math.min(stack.spoil_percent + 0.5, 0.95) }
    if not stack.can_set_stack(new_cell) then return end
    if stack.spoil_percent < 0.1 then
        if storage.stabilizer.entity.burner.remaining_burning_fuel < M.ENERGY_PER_CELL * 0.1 then
            return
        end
        storage.stabilizer.entity.burner.remaining_burning_fuel = storage.stabilizer.entity.burner.remaining_burning_fuel - M.ENERGY_PER_CELL * 0.1
    end
    storage.stabilizer.fuel.cells[item.item_number] = nil
    local label = item.label
    stack.set_stack(new_cell)
    stack.label = label or ""
    burner.currently_burning = burner.currently_burning or "rabbasca-warp-cell-internal"
    storage.stabilizer.fuel.cells[stack.item_number] = { item = stack.item, tether = target, tether_capacity = burner.currently_burning.name.fuel_value }
end

function M.untether(item)
    local stack = item.item_stack
    if not stack then return end
    storage.stabilizer.fuel.cells[item.item_number] = nil
    local label = item.label
    local empty_cell = { name = "rabbasca-warp-cell-recharging", count = 1, quality = item.quality }
    stack.set_stack(empty_cell)
    stack.label = label or ""
    storage.stabilizer.fuel.cells[stack.item_number] = { item = stack.item, tether = nil, tether_capacity = 0 }
end

function M.update_cells()
    local ticks_per_second = 6
    local is_recalling = storage.stabilizer.entity.is_crafting() and storage.stabilizer.entity.get_recipe().name == "rabbasca-stabilizer-recharge"
    local stab_inv = storage.stabilizer.entity.get_inventory(defines.inventory.burnt_result)
    local can_fuel = storage.stabilizer.entity.burner.remaining_burning_fuel > 0
    local refuelled = 0
    local refuel_spoilage_per_tick = 0.025 / ticks_per_second
    for n, data in pairs(storage.stabilizer.fuel.cells) do
        local cell = data.item
        if not cell.valid then
            storage.stabilizer.fuel.cells[n] = nil
            break
        else
            local stack = cell.item_stack or stab_inv.find_empty_stack()
            if (not cell.item_stack) or cell.item_stack.spoil_percent >= 0.995 then
                M.untether(cell)
                break
            else
                if data.tether then
                    if data.tether.valid and data.tether.burner then
                        local delta = (1 - cell.item_stack.spoil_percent) * M.ENERGY_PER_CELL / ticks_per_second
                        if not data.tether.burner.currently_burning then
                            data.tether.burner.currently_burning = "rabbasca-warp-cell-internal"
                            data.tether.burner.remaining_burning_fuel = delta
                        else
                            data.tether.burner.remaining_burning_fuel = data.tether.burner.remaining_burning_fuel + delta
                        end
                        stack.health = math.max(0, math.min(1, data.tether.burner.remaining_burning_fuel / (data.tether_capacity or 1)))
                    else
                        M.untether(cell)
                    end
                end
                local is_in_stab = cell.owner_location.entity == storage.stabilizer.entity
                if is_recalling and not is_in_stab then
                        local swap, _ = stab_inv.find_empty_stack()
                        stack.swap_stack(swap)
                elseif is_in_stab and can_fuel and data.tether and cell.item_stack.spoil_percent > refuel_spoilage_per_tick then
                    refuelled = refuelled + 1
                    cell.item_stack.spoil_percent = math.max(0, cell.item_stack.spoil_percent - refuel_spoilage_per_tick)
                end
            end
        end
    end
    storage.stabilizer.entity.burner.remaining_burning_fuel = storage.stabilizer.entity.burner.remaining_burning_fuel - refuelled * M.ENERGY_PER_CELL * 0.05 / ticks_per_second
end

function M.on_consumer_died(id)
    if storage.stabilizer and storage.stabilizer.fuel.consumers then
        storage.stabilizer.fuel.consumers[id] = nil
    end
end

function M.register_consumer(e)
    if not (storage.stabilizer and storage.stabilizer.entity.valid) then return end
    local id, _, _ = script.register_on_object_destroyed(e)
    storage.stabilizer.fuel.consumers[id] = { entity = e, targeted_by = { }  }
    if e.burner.currently_burning == nil then
        e.burner.currently_burning = "rabbasca-warp-cell-internal"
    end
    -- game.print("Registered fuel consumer: "..e.gps_tag..", now have "..table_size(storage.stabilizer.fuel.consumers))
end

return M