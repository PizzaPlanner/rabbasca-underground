local M = { }

local function matches_strategy(strategy, i, current, inv)
    if strategy.filter == 2 and not (inv.get_item_count("rabbasca-warp-cell-recharging") == 0) then 
        return false
    elseif strategy.filter == 3 and not (inv.get_item_count("rabbasca-warp-cell-recharging") > 0 and inv.can_insert("rabbasca-warp-trace")) then
        return false
    elseif strategy.filter == 4 and not (inv.get_item_count("rabbasca-warp-cell") > 0) then
        return false
    elseif strategy.filter == 5 and not (inv.get_item_count("rabbasca-warp-cell") == 0) then
        return false
    end
    if strategy.cycle then
        return i > current, true
    else 
        return true
    end
end

function M.set_fueller_target()
    local ce = storage.stabilizer.fuel.recharger
    if not ce then return end
    local strategy = storage.stabilizer.fuel.selection_strategy
    if strategy == nil or strategy.filter == 1 then return end
    ce.proxy_target_inventory = strategy.filter > 3 and defines.inventory.fuel or defines.inventory.burnt_result
    local current = storage.stabilizer.fuel.current or -1
    local cycle_first = math.huge
    for i, e in pairs(storage.stabilizer.fuel.consumers) do
        if not e.valid then return end -- right after sanitize; should never happen

        local trash = e.get_inventory(ce.proxy_target_inventory)
        local hit, cycle_match = matches_strategy(strategy, i, current, trash)
        if hit then
            ce.proxy_target_entity = e
            storage.stabilizer.fuel.current = i
            return
        elseif cycle_match and i < cycle_first then
            cycle_first = i
        end
    end
    if cycle_first < math.huge then
        storage.stabilizer.fuel.current = cycle_first
        ce.proxy_target_entity = storage.stabilizer.fuel.consumers[cycle_first]
    else
        ce.proxy_target_entity = nil
        storage.stabilizer.fuel.current = -1
    end
end

function M.sanitize_conumers()
    local c = { }
    for _, e in pairs(storage.stabilizer.fuel.consumers) do
        if e.valid then
            table.insert(c, e)
        end
    end
    storage.stabilizer.fuel.consumers = c
end

function M.attempt_cell_recharge(inventory_owner, auto_refuel)
    if not (inventory_owner and inventory_owner.valid) then return end
    local inventories_from = { defines.inventory.burnt_result, defines.inventory.fuel, defines.inventory.chest }
    for _, idx in pairs(inventories_from) do
        local inv = inventory_owner.get_inventory(idx)
        local cells = inv and inv.get_item_count("rabbasca-warp-cell-recharging") or 0
        local pity_per = 0.001 + 0.00075 / cells
        if cells > 0 then
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

return M