data:extend {
  {
    type = "noise-expression",
    name = "rabbasca_underground_starting_island",
    expression = "max(abs(x), abs(y)) < 16"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_elevation",
    expression =  "rabbasca_underground_starting_island" --"max(rabbasca_underground_starting_island, rabbasca_underground_resource_spots)"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_lava",
    expression = "0"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_edge",
    expression = "distance - 96"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_anomaly_chance",
    expression = "(voronoi_spot_noise{x = x, y = y, seed0 = map_seed, seed1 = 'randombob', grid_size = 7, distance_type = 'manhattan', jitter = 1} < 0.05) * (distance > 17)"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_anomaly_richness",
    expression = "10 + basis_noise{x = x, y = y, input_scale = 8, output_scale = 10, seed0 = map_seed, seed1 = 'whatwasthat'}"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_lithium_amide",
    expression = "rabbasca_underground_high_spots - 0.25"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_resources",
    expression = "(0.7 - rabbasca_underground_elevation)\z
                  * (0.7 + multioctave_noise{x = x, y = y, persistence = 0.57, seed0 = map_seed, seed1 = 'kindoflikeasteroidcrushing', input_scale = 0.5, output_scale = 0.3, octaves = 3 })"
  },
}