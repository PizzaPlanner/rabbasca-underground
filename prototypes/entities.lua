local stabilizer = util.merge { data.raw["assembling-machine"]["assembling-machine-3"],
{
    name = "rabbasca-warp-stabilizer",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    max_health = 10000,
    production_health_effect = {
      producing = 5 / second,
      not_producing = 5 / second
    },
    crafting_speed = 1,
    collision_box = {{-4.2, -4.2}, {4.2, 4.2}},
    selection_box = {{-4.5, -4.5}, {4.5, 4.5}},
    energy_usage = "1GW",
    energy_source = {
      type = "burner",
      fuel_inventory_size = 1,
      fuel_categories = { "rabbasca-warp-anomaly" },
      initial_fuel = "rabbasca-warp-matrix",
      initial_fuel_percent = 0.5
    },
    module_slots = 20,
    trash_inventory_size = 19,
    hidden = false,
    hidden_in_factoriopedia = false,
    subgroup = "rabbasca-warp-stabilizer",
    order = "a[stabilizer]",
}}
stabilizer.circuit_wire_max_distance = 0
stabilizer.ignore_output_full = false
if settings.startup["rabbasca-underground-can-pause-stabilizer"].value == false then
  stabilizer.enable_logistic_control_behavior = false
end
stabilizer.minable = nil
stabilizer.placeable_by = nil
stabilizer.allowed_effects = { "speed", "productivity", "quality" }
stabilizer.flags = { "placeable-player", "player-creation" }
-- stabilizer.energy_source = {
--   type = "electric",
--   buffer_capacity = "1GJ",
--   usage_priority = "primary-input",
-- }
stabilizer.next_upgrade = nil
stabilizer.deconstruction_alternative = nil
stabilizer.crafting_categories = { "rabbasca-warp-stabilizer" }
local sprite_data = {   
  line_length = 10,
  width = 4000 / 10,
  height = 3840 / 8,
  frame_count = 80,
  scale = 0.8,
  shift = util.by_pixel(0, -20)
}

stabilizer.graphics_set = {
  animation = { layers = {
      util.merge { sprite_data, { filename = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-animation.png" } },
      util.merge { sprite_data, { filename = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-shadow.png", width = 900, height = 500, frame_count = 1, repeat_count = 80, line_length = 1, draw_as_shadow = true } },
  }},
  working_visualisations = {
    {
      fadeout = true,
      animation = util.merge { sprite_data, 
      { filename = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-emission1.png", draw_as_glow = true, blend_mode = "additive", apply_runtime_tint = true }},
      apply_recipe_tint = "primary"
    },
    {
      fadeout = true, 
      animation = util.merge { sprite_data, 
      { filename = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-emission2.png", draw_as_glow = true, blend_mode = "additive" }},
    },
  },
}

local lab = util.merge {
  data.raw["lab"]["lab"],
  {
    name = "rabbasca-warp-tech-analyzer",
    energy_usage = "10MW",
    burns_fluid = true,
    scale_fluid_usage = true,
    placeable_by = { item = "rabbasca-warp-tech-analyzer", count = 1 }
  }
}
lab.inputs = { "rabbasca-warp-matrix", "rabbasca-coordinate-system", "rabbasca-spacetime-sensor", "rabbasca-spatial-anchor", "rabbasca-quantum-device" }
lab.minable.result = "rabbasca-warp-tech-analyzer"
lab.energy_source = {
  type = "fluid",
  fluid_box = {
    volume = 20,
    filter = "fusion-plasma",
    pipe_picture = assembler2pipepictures(),
    pipe_covers = pipecoverspictures(),
    production_type = "input",
    pipe_connections = 
    {
        {
          flow_direction = "input-output",
          position = {0, -1.2},
          direction = defines.direction.north,
          connection_category = "fusion-plasma",
        },
        {
          flow_direction = "input-output",
          position = {0, 1.2},
          direction = defines.direction.south,
          connection_category = "fusion-plasma",
        },
        {
          flow_direction = "input-output",
          position = {1.2, 0},
          direction = defines.direction.east,
          connection_category = "fusion-plasma",
        },
        {
          flow_direction = "input-output",
          position = {-1.2, 0},
          direction = defines.direction.west,
          connection_category = "fusion-plasma",
        },
    },
  },
}

local minelon  = util.merge {
  data.raw["assembling-machine"]["rabbasca-warp-pylon"],
  {
    name = "rabbasca-collector-pylon",
    type = "mining-drill",
    resource_searching_radius = 8,
    shuffle_resources_to_mine = true,
    mining_speed = 1,
    resource_categories = { "rabbasca-warp-anomaly" },
    vector_to_place_result = { 0, 1.25 },
    uses_force_mining_productivity_bonus = false,
    quality_affects_mining_radius = true,
    minable = { result = "rabbasca-collector-pylon" }
  }
}
minelon.allowed_effects = {"speed", "productivity", "quality"}
minelon.flags = { "placeable-player", "player-creation" }

local passive_miner = util.merge {
  data.raw["electric-energy-interface"]["rabbasca-energy-source"],
  {
    name = "rabbasca-stabilizer-consumer",
    type = "mining-drill",
    icon = stabilizer.icon,
    factoriopedia_alternative = "rabbasca-warp-stabilizer",
    resource_searching_radius = 100,
    shuffle_resources_to_mine = true,
    mining_speed = 10,
    resource_categories = { "rabbasca-warp-anomaly" },
    vector_to_place_result = { 0, 0 },
    uses_force_mining_productivity_bonus = false,
    quality_affects_mining_radius = false,
    energy_source = { type = "void", },
    energy_usage = Rabbasca.surface_megawatts() * 50 .. "MW",
    alert_icon_shift = { 0, 32 },
    alert_icon_scale = 2
  }
}
passive_miner.allowed_effects = { }
data:extend {
  stabilizer,
  lab,
  minelon,
  passive_miner,
  util.merge {
    data.raw["electric-energy-interface"]["rabbasca-energy-source"],
    {
      name = "rabbasca-platform-energy-source",
      icons = Rabbasca.icons({{ proto = data.raw["fluid"]["harene"]}}),
      energy_production = Rabbasca.surface_megawatts() * 0.1 .. "MW",
      energy_source = { 
        type = "electric", 
        usage_priority = "primary-output", 
        buffer_capacity = (Rabbasca.surface_megawatts() * 0.1 / 6) .. "MJ", 
        output_flow_limit = Rabbasca.surface_megawatts() * 0.1 .. "MW",
        render_no_power_icon = false
      },
    }
  }
}