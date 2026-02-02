local config = data.raw["mod-data"]["rabbasca-stabilizer-config"].data
local planet = data.raw["planet"]["rabbasca-underground"]
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
    table.insert(config.water_tiles, water_tile)
    c.fluid = data.raw["tile"][water_tile].fluid

    log("Underground: added "..planet.. " with "..serpent.line(c))
end

table.insert(lut_table, { current_lut_step + lut_step, "__rabbasca-assets__/graphics/recolor/textures/lut-white.png" })
table.insert(lut_table, { current_lut_step + lut_step, "identity" })
planet.surface_render_parameters.day_night_cycle_color_lookup = lut_table

if planet_count < 2 then
    log("ERROR: Underground planet count is too low: "..planet_count..". Game will now crash")
    data.raw["crash"]["too-few-planets"] = 3
end