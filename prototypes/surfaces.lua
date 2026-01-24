data:extend { 
  {
    type = "surface-property",
    name = "rabbasca-underground",
    default_value = 0,
    hidden = true,
    hidden_in_factoriopedia = true
  },
  {
    type = "planet",
    name = "rabbasca-underground",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png", 
    icon_size = 640,
    hidden = true,
    hidden_in_factoriopedia = false,
    draw_orbit = false,
    distance = 10,
    orientation = 0,
    subgroup = "satellites",
    -- subgroup = "rabbasca-warp-stabilizer",
    order = "c[gleba]-r[rabbasca]-a[surface]",
    surface_properties = {
        ["rabbasca-underground"] = 1,
        ["gravity"] = 14,
        ["solar-power"] = 0,
        ["pressure"] = Rabbasca.underground_pressure(),
        ["magnetic-field"] = 45,
        ["harenic-energy-signatures"] = Rabbasca.surface_megawatts() * 0.1,
    },
    map_gen_settings = {
      -- cliff_settings = {
      --   name = "rabbasca-underground-cliff",
      --   cliff_elevation_0 = 0.1,
      --   cliff_elevation_interval = 0.6,
      --   cliff_smoothing = 0,
      --   -- richness = 10,
      -- },
      property_expression_names = {
        elevation = "rabbasca_underground_elevation",
        -- cliff_elevation = "rabbasca_underground_elevation",
        -- cliffiness = "0.3",
      },
      autoplace_controls = { },
      autoplace_settings = {
        tile = { settings = {
          ["rabbasca-underground-rubble"] = {},
          ["rabbasca-underground-out-of-map"] = {},
          ["rabbasca-underground-empty-space"] = {},
        }},
        entity = { settings = { }} -- filled in script
      },
      territory_settings =
      {
        units = {"rabbasca-underground-devourer"},
        territory_index_expression = "rabbasca_devourer_territory_expression",
        territory_variation_expression = "demolisher_variation_expression",
        minimum_territory_size = 8
      },
    },
    surface_render_parameters = {
      shadow_opacity = 0.3,
      draw_sprite_clouds = false,
      clouds = nil,
      day_night_cycle_color_lookup = {
          {0.0, "identity"},
          {1.0, "identity"},
      },
      fog = util.merge {
        data.raw["planet"]["vulcanus"].surface_render_parameters.fog,
        {
          color1 = {0.7, 0.7, 0.7},
          color2 = {0.4, 0.4,  0.4},
          tick_factor = 0.0005,
        }
      }
    },
  },
  util.merge{
    data.raw["surface"]["space-platform"],
    {
      name = "rabbasca-space-platform",
    }
  }
}

data.raw["surface"]["rabbasca-space-platform"].surface_properties["harenic-energy-signatures"] = Rabbasca.surface_megawatts() * 0.1