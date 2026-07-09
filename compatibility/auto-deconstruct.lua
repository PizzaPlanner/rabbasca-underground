-- Underground resources vanish and reappear frequently, so dont clean up on them
if not data.raw["mod-data"]["autodeconstruct-blacklist"] then return end

if data.raw["mod-data"]["autodeconstruct-blacklist"].data.surfaces then
    table.insert(data.raw["mod-data"]["autodeconstruct-blacklist"].data.surfaces, "rabbasca%-underground")
end