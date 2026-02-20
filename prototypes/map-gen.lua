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
    name = "rabbasca_underground_edge",
    expression = "distance - 96"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_anomaly_chance",
    expression = "aquilo_spot_noise{seed = 4567801,\z
                                    count = 2,\z
                                    skip_offset = 0,\z
                                    region_size = 28,\z
                                    density = 0.6,\z
                                    radius = 3,\z
                                    favorability = 1} > 0.95"
  },
  {
    type = "noise-expression",
    name = "rabbasca_underground_anomaly_richness",
    expression = "153 + basis_noise{x = x, y = y, input_scale = 0.82, output_scale = 26, seed0 = map_seed, seed1 = 'whatwasthat'}"
  },
}