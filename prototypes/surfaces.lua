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
    hidden = true, -- dont show up in space map
    hidden_in_factoriopedia = false,
    draw_orbit = false,
    label_orientation = 0.625,
    magnitude = 0.5,
    distance = 75,
    orientation = 0.125,
    subgroup = "satellites",
    -- subgroup = "rabbasca-warp-stabilizer",
    order = "c[gleba]-r[rabbasca]-a[surface]",
    -- orbit = {
    --   orientation = 0.625,
    --   distance = 1.5,
    --   parent = {
    --     type = "planet",
    --     name = "rabbasca",
    --   },
    --   sprite = {
    --     type = "sprite",
    --     filename = "__rabbasca-assets__/graphics/textures/stabilizer-orbit.png",
    --     size = 470,
    --     scale = 0.2,
    --   }
    -- },
    surface_properties = {
        ["rabbasca-underground"] = 1,
        ["gravity"] = 15,
        ["robot-energy-usage"] = 0.5,
        ["solar-power"] = 0,
        ["pressure"] = Rabbasca.underground_pressure(),
        ["magnetic-field"] = 45,
        ["harenic-energy-signatures"] = Rabbasca.surface_megawatts() * 0.1,
        ["rabbasca-or-space"] = 1,
    },
    map_gen_settings = {
      property_expression_names = {
        elevation = "rabbasca_underground_elevation",
      },
      autoplace_controls = { },
      autoplace_settings = {
        tile = { settings = {
          ["rabbasca-underground-rubble"] = {},
          ["rabbasca-underground-out-of-map"] = {},
        }},
        entity = { settings = { 
          ["rabbasca-warp-anomaly"] = { },
        } }
      },
    },
    surface_render_parameters = {
      shadow_opacity = 0.3,
      draw_sprite_clouds = false,
      clouds = nil,
      day_night_cycle_color_lookup = {
          -- fill in final-fixes
          {0.0, "identity"},
          {1.0, "identity"},
      },
      fog = util.merge {
        data.raw["planet"]["vulcanus"].surface_render_parameters.fog,
        {
          color1 = {0.7, 0.7, 0.7},
          color2 = {0.4, 0.4,  0.4},
          tick_factor = 0.000005,
        }
      }
    },
  },
}