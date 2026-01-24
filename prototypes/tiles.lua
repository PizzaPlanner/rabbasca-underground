table.insert(out_of_map_tile_type_names, "rabbasca-underground-out-of-map")

data:extend {
util.merge{ table.deepcopy(data.raw["tile"]["volcanic-folds"]), {
    name = "rabbasca-underground-rubble",
    autoplace = { probability_expression = "rabbasca_underground_elevation" },
    map_color = { 0.17, 0.06, 0.1 },
}},
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