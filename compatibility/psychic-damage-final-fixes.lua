local function make_psychic_weak(proto, mult)
    local res = table.deepcopy(proto.resistances or { }) -- demolishers share resistances, deepcopy to make individual
    if not util.contains_value(proto.flags or { }, "breaths-air") then return end
    for _, r in pairs(res) do
        if r.type == "poison" and r.percent and r.percent > 95 then return end
        if r.type == "rabbasca-psychic" then return end
    end
    table.insert(res, { type = "rabbasca-psychic", percent = -100 * math.floor(mult * math.sqrt((proto.max_health or 10)/3)) })
    proto.resistances = res
end

for _, thing in pairs(data.raw["character"]) do
    make_psychic_weak(thing, 1)
end
for _, thing in pairs(data.raw["unit"]) do
    make_psychic_weak(thing, 2)
end
for _, thing in pairs(data.raw["spider-unit"]) do
    make_psychic_weak(thing, 2)
end
for _, thing in pairs(data.raw["unit-spawner"]) do
    make_psychic_weak(thing, 5)
end
for _, thing in pairs(data.raw["segmented-unit"]) do
    make_psychic_weak(thing, 4)
end
for _, thing in pairs(data.raw["segment"]) do
    make_psychic_weak(thing, 4)
end