for _, furnace in pairs(data.raw["furnace"]) do
    for _, cat in pairs(furnace.crafting_categories) do
        if cat == "recycling" then
            furnace.surface_conditions = furnace.surface_conditions or { }
            table.insert(furnace.surface_conditions, Rabbasca.not_underground())
        end
    end
end
for _, furnace in pairs(data.raw["assembling-machine"]) do
    for _, cat in pairs(furnace.crafting_categories) do
        if cat == "recycling" then
            furnace.surface_conditions = furnace.surface_conditions or { }
            table.insert(furnace.surface_conditions, Rabbasca.not_underground())
        end
    end
end

require("prototypes.stabilizer-config-final-fixes")