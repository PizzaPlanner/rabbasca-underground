table.insert(out_of_map_tile_type_names, "rabbasca-underground-out-of-map")

local rubble_unp = util.merge{ table.deepcopy(data.raw["tile"]["haronite-plate"]), {
    name = "rabbasca-underground-rubble",
    autoplace = { probability_expression = "rabbasca_underground_starting_island" },
    map_color = { 0.17, 0.06, 0.1 },
    collision_mask = { layers = { harene = true } },
    allows_being_covered = false
}}
rubble_unp.minable = nil

local rubble_p = util.merge{rubble_unp, { 
  name = "rabbasca-underground-rubble-powered",
  variants = { 
    material_background = { picture = "__rabbasca-assets__/graphics/by-openai/safe-zone.png", },         
    material_texture_width_in_tiles = 32,
    material_texture_height_in_tiles = 32, 
  },
}}
rubble_p.autoplace = nil

data:extend {
rubble_unp, rubble_p,
util.merge { 
    table.deepcopy(data.raw["tile"]["out-of-map"]),
    {
      name = "rabbasca-underground-out-of-map",
      autoplace = { probability_expression = "rabbasca_underground_starting_island == 0" }
    }
},
}