if not settings.startup["rabbasca-underground-full-spaghetti-mode"].value then return end
-- Do NOT restrict requester chests, we need warp uplink available

for _, proto in pairs(data.raw["roboport"]) do
    if not proto.name:find("^rabbasca") then
        proto.surface_conditions = proto.surface_conditions or { }
        table.insert(proto.surface_conditions, Rabbasca.not_underground())
    end
end