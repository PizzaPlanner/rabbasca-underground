local fuel = require("scripts.fuel")
require("util")

if not storage.stabilizer then return end
if not storage.stabilizer.entity.valid then return end
if not storage.stabilizer.fuel then return end
if not storage.stabilizer.fuel.inventory then
    storage.stabilizer.fuel.inventory = fuel.create_inventory()
end

local copied_table = { } -- TODO: import deepcopy?
for i, data in pairs(storage.stabilizer.fuel.cells) do
    copied_table[i] = data
end

local transferred = 0
for i, data in pairs(copied_table) do
    local cell = data.item
    if cell.valid then
        if cell.item_stack then
            storage.stabilizer.fuel.inventory.transfer_from_stack(cell.item_stack)
        else
            fuel.untether(cell, true)
        end
    else
        fuel.untether({ item_number = i }, true)
    end
    transferred = transferred + 1
end
game.print("[entity=rabbasca-warp-stabilizer] Update 0.8.0 changed how [item=rabbasca-warp-cell] are stored. [color=yellow]"..transferred.."[/color] cells have been transferred to warp cell storage.")