-- Underground resources vanish and reappear frequently, so dont clean up on them
local setting = data.raw["string-setting"]["autodeconstruct-ore-blacklist"]
if not setting then return end
for _, config in pairs(data.raw["mod-data"]["rabbasca-stabilizer-config"]) do
    for name, _ in pairs(config.autoplace_entities) do
        if data.raw["resource"][name] then
            local old_value = setting.default_value
            if old_value ~= "" then
                old_value = old_value .. ","
            end
            setting.default_value = old_value .. name
        end
    end
end