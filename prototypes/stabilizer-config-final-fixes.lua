local config = data.raw["mod-data"]["rabbasca-stabilizer-config"].data
local planet_count = table_size(config.planets)
local lut_table = { 
    { 0.0, "identity" } -- to make fog of war normal color
}
config.planet_count = planet_count
local lut_step = 1 / (3 + 2 * planet_count)
local current_lut_step = 0
for planet, c in pairs(config.planets) do
    -- Lighting
    current_lut_step = current_lut_step + lut_step
    table.insert(lut_table, {current_lut_step, "__rabbasca-assets__/graphics/recolor/textures/lut-white.png"})
    current_lut_step = current_lut_step + lut_step
    c.lut_index = current_lut_step
    table.insert(lut_table, {current_lut_step, c.lut or "identity"})

    -- Water
    local water_tile = c.water or "hot-lava"
    assert(data.raw["tile"][water_tile], "Not a valid filler_tile for "..planet..": "..water_tile)
    c.fluid = data.raw["tile"][water_tile].fluid

    log("added warp location "..planet.. " with "..serpent.line(c))
    assert(data.raw["planet"][planet], "Not a valid planet: "..planet)
    for _, e in pairs(c.anomaly_replace_entities) do
        if e.type == "resource" then
            assert(data.raw["tile"][e.floor], "not a valid floor tile for "..planet..": "..e.floor)
            assert(data.raw["resource"][e.name], "not a valid resource for "..planet..": "..e.name)
        end
    end
end

table.insert(lut_table, { current_lut_step + lut_step, "__rabbasca-assets__/graphics/recolor/textures/lut-white.png" })
table.insert(lut_table, { current_lut_step + lut_step, "identity" })
local planet = data.raw["planet"]["rabbasca-underground"]
planet.surface_render_parameters.day_night_cycle_color_lookup = lut_table

assert(planet_count >= 2, "at least two underground destinations required (found "..planet_count..")")

for _, tech in pairs(data.raw["technology"]) do
    if tech.rabbasca_underground_temporary then
        table.insert(config.per_surface_techs, tech.name)
    end
end