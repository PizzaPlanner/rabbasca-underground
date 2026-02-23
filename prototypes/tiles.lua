table.insert(out_of_map_tile_type_names, "rabbasca-underground-out-of-map")

local rubble_unp = util.merge{ data.raw["tile"]["tutorial-grid"], {
    name = "rabbasca-underground-rubble",
    autoplace = { probability_expression = "rabbasca_underground_starting_island" },
    map_color = { 0.17, 0.06, 0.1 },
    collision_mask = { layers = { harene = true } },
    allows_being_covered = false,
    hidden = false
}}
rubble_unp.minable = nil

local rubble_p = util.merge{rubble_unp, { 
  name = "rabbasca-underground-rubble-powered",
  variants = { 
    main = {
      { picture = "__rabbasca-assets__/graphics/recolor/textures/tutorial-grid1.png" },
      { picture = "__rabbasca-assets__/graphics/recolor/textures/tutorial-grid2.png" },
    },
  },
}}
rubble_p.tint = { 0.85, 0.9, 0.97 }
rubble_p.autoplace = nil

data:extend {
rubble_unp, rubble_p,
util.merge { 
    data.raw["tile"]["out-of-map"],
    {
      name = "rabbasca-underground-out-of-map",
      autoplace = { probability_expression = "rabbasca_underground_starting_island == 0" }
    }
},
}