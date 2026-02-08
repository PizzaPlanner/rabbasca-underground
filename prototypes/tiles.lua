table.insert(out_of_map_tile_type_names, "rabbasca-underground-out-of-map")

local rubble_unp = util.merge{ table.deepcopy(data.raw["tile"]["refined-concrete"]), {
    name = "rabbasca-underground-rubble",
    autoplace = { probability_expression = "rabbasca_underground_starting_island" },
    map_color = { 0.17, 0.06, 0.1 },
    collision_mask = { layers = { harene = true } },
}}

local rubble_p = util.merge{rubble_unp, { 
  name = "rabbasca-underground-rubble-powered",
  variants = { material_background = { picture = "__rabbasca-assets__/graphics/recolor/textures/powered-ug-floor.png", } },
}}
rubble_p.autoplace = nil

data:extend {
rubble_unp, rubble_p,
util.merge { 
    table.deepcopy(data.raw["tile"]["out-of-map"]),
    {
      name = "rabbasca-underground-out-of-map",
      autoplace = { probability_expression = "rabbasca_underground_edge" }
    }
},
util.merge { 
    table.deepcopy(data.raw["tile"]["empty-space"]),
    {
      name = "rabbasca-underground-empty-space",
      autoplace = { probability_expression = "rabbasca_underground_lava" }
    }
}}