if not settings.startup["rabbasca-expand-warpfield-science-usage"].value then return end

local techs = { "stellar-discovery-solar-system-edge", "promethium-science-pack", "research-productivity" }
for _, tech in pairs(techs) do
    local t = data.raw["technology"][tech]
    if t and t.unit and t.unit.ingredients then
        local has_cryo_science = 0
        local has_ath_science = false
        for _, pack in pairs(t.unit.ingredients) do
            if pack[1] == "cryogenic-science-pack" then
                has_cryo_science = pack[2]
            elseif pack[1] == "rabbasca-warpfield-science-pack" then
                has_ath_science = true
            end
        end
        if has_cryo_science > 0 and not has_ath_science then
            table.insert(t.unit.ingredients, { "rabbasca-warpfield-science-pack", has_cryo_science })
            table.insert(t.unit.ingredients, { "rabbasca-imaginary-science-pack", has_cryo_science })
            table.insert(t.prerequisites, "rabbasca-warpfield-science-pack")
            table.insert(t.prerequisites, "rabbasca-imaginary-science-pack")
        end
    end
end