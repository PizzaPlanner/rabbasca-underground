data:extend {
  {
    type = "noise-expression",
    name = "rabbasca_underground_starting_island",
    expression = "102 - distance + 12 * basis_noise{x = x, y = y, seed0 = map_seed, seed1 = 'warpten', input_scale = 1/3 }"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_elevation",
    expression = "max(rabbasca_underground_starting_island, rabbasca_underground_resource_spots)"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_lava",
    expression = "0"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_edge",
    expression = "distance - 164"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_resource_spots",
    expression = "max(\z
                    starting_spot_at_angle{angle = map_seed,       distance = 45, radius = 5, x_distortion = 0, y_distortion = 0},\z
                    starting_spot_at_angle{angle = map_seed + 143, distance = 60, radius = 7, x_distortion = 0, y_distortion = 0}) * 0.8\z 
                  + multioctave_noise{x = x, y = y, persistence = 0.57, seed0 = map_seed, seed1 = 'whatsupnextbro', input_scale = 0.5, output_scale = 0.25, octaves = 2 }"
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