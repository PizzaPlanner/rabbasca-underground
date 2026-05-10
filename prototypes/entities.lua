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
    collision_box = {{-3.7, -3.7}, {3.7, 3.7}},
    selection_box = {{-4, -4}, {4, 4}},
    energy_usage = "10MW",
    energy_source = { type = "void" },
    -- fixed_recipe = "rabbasca-stabilize-warpfield",
    module_slots = 20,
    trash_inventory_size = 10,
    hidden = false,
    hidden_in_factoriopedia = false,
    subgroup = "rabbasca-warp-stabilizer",
    order = "a[stabilizer]",
}}
stabilizer.effect_receiver = {
  base_effect = { consumption = 4 },
  uses_module_effects = true,
  uses_beacon_effects = false,
  uses_surface_effects = false
}
stabilizer.circuit_wire_max_distance = 120
stabilizer.ignore_output_full = false
stabilizer.minable = nil
stabilizer.placeable_by = nil
stabilizer.allowed_effects = { "speed", "consumption", "pollution" }
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
  scale = 0.72,
  shift = util.by_pixel(0, -25)
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

local rh_spritedata = {
  line_length = 10,
  width = 5900 / 10,
  height = 5120 / 8,
  frame_count = 80,
  scale = 0.25,
  shift = util.by_pixel(0, -20)
}
local relichunter = {
  name = "rabbasca-relichunter",
  icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon.png",
  icon_size = 64,
  type = "assembling-machine",
  flags = { "placeable-player" },
  collision_box = {{-1.8, -1.8},{1.8, 1.8}},
  selection_box = {{-2, -2},{2, 2}},
  crafting_speed = 1,
  module_slots = 0,
  crafting_categories = { "rabbasca-relichunter" },
  energy_usage = "2MW",
  energy_source = {
    type = "burner",
    fuel_inventory_size = 1,
    burnt_inventory_size = 10,
    fuel_categories = { "rabbasca-warp-anomaly" },
  },
  fixed_recipe = "rabbasca-hunt-relicaries",
  hidden = false,
  hidden_in_factoriopedia = false,
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[stabilizer]-c[relichunter]",
  graphics_set = {
    animation = { layers = {
          util.merge { rh_spritedata, { filename = "__rabbasca-assets__/graphics/by-hurricane/research-center-animation.png" } },
          util.merge { rh_spritedata, { filename = "__rabbasca-assets__/graphics/by-hurricane/research-center-hr-shadow.png", width = 1200, height = 700, frame_count = 1, repeat_count = 80, line_length = 1, draw_as_shadow = true } },
      }},
      working_visualisations = {
        {
          fadeout = true,
          animation = util.merge { rh_spritedata, 
          { filename = "__rabbasca-assets__/graphics/by-hurricane/research-center-emission1.png", draw_as_glow = true, blend_mode = "additive" }},
        },
        {
          fadeout = true, 
          animation = util.merge { rh_spritedata, 
          { filename = "__rabbasca-assets__/graphics/by-hurricane/research-center-emission2.png", draw_as_glow = true, blend_mode = "additive" }},
        },
      },
  }
}

local relicary = {
  name = "rabbasca-relicary",
  icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
  type = "furnace",
  max_health = 100,
  -- production_health_effect = {
  --   producing = -8 / second,
  --   not_producing = 0
  -- },
  flags = { "placeable-neutral", "not-repairable", "not-deconstructable" },
  collision_box = {{-0.9, -0.9},{0.9, 0.9}},
  selection_box = {{-1, -1},{1, 1}},
  enable_logistic_control_behavior = false,
  result_inventory_size = 10,
  source_inventory_size = 1,
  crafting_speed = 1,
  energy_usage = "8W",
  energy_source = {
    type = "burner",
    burner_usage = "fuel",
    effectivity = 1,
    fuel_categories = { "rabbasca-relicary" },
    fuel_inventory_size = 1,
    burnt_inventory_size = 1
  },
  module_slots = 0,
  crafting_categories = { "rabbasca-relics" },
  -- cant_insert_at_source_message_key = "inventory-restriction.not-a-vault-key",
  graphics_set = table.deepcopy(data.raw["assembling-machine"]["rabbasca-vault-console"].graphics_set)
}

local relicary_access = {
  name = "rabbasca-relicary-remote",
  icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
  type = "proxy-container",
  flags = { "placeable-player" },
  placeable_by = { item = "rabbasca-relicary-remote", count = 1 },
  draw_inventory_content = true,
  max_health = 100,
  picture = table.deepcopy(data.raw["linked-container"]["linked-chest"].picture),
  collision_box = {{-0.4, -0.4},{0.4, 0.4}},
  selection_box = {{-0.5, -0.5},{0.5, 0.5}},
  surface_conditions = { Rabbasca.only_underground(true) }
}

local miner_remote = {
  name = "rabbasca-miner-remote",
  icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
  type = "proxy-container",
  flags = { "placeable-player", "not-selectable-in-game", "not-on-map", "not-deconstructable", "no-automated-item-removal", "not-blueprintable" },
  draw_inventory_content = false,
  max_health = 100,
  collision_box = {{-0.2, -0.2},{0.2, 0.2}},
  -- selection_box = {{-0.5, -0.5},{0.5, 0.5}},
  surface_conditions = { Rabbasca.only_underground(true) },
  collision_mask = {
    layers = { },
    colliding_with_tiles_only = true
  },
}

local fuel_access = {
  name = "rabbasca-fuel-remote",
  icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
  type = "proxy-container",
  circuit_wire_max_distance = 90,
  ignore_output_full = false,
  minable = nil,
  placeable_by = nil,
  allowed_effects = { "speed", "consumption", "pollution" },
  flags = { "placeable-player", "player-creation" },
  next_upgrade = nil,
  deconstruction_alternative = nil,
  draw_inventory_content = true,
  max_health = 100,
  picture = table.deepcopy(data.raw["linked-container"]["linked-chest"].picture),
  collision_box = {{-0.8, -0.8},{0.8, 0.8}},
  selection_box = {{-1, -1},{1, 1}},
  surface_conditions = { Rabbasca.only_underground(true) }
}


local lab = util.merge {
  data.raw["lab"]["lab"],
  {
    name = "rabbasca-warp-tech-analyzer",
    energy_usage = "5MW",
    placeable_by = { item = "rabbasca-warp-tech-analyzer", count = 1 }
  }
}
lab.inputs = { "rabbasca-warp-anomaly", "rabbasca-warp-trace", "rabbasca-twisted-knowledge" }
lab.minable.result = "rabbasca-warp-tech-analyzer"

local minelon = util.merge {
  data.raw["assembling-machine"]["rabbasca-warp-pylon"],
  {
    name = "rabbasca-collector-pylon",
    type = "mining-drill",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-2.png",
    resource_searching_radius = 1.5,
    shuffle_resources_to_mine = false,
    mining_speed = 5,
    resource_categories = { "rabbasca-warp-anomaly" },
    vector_to_place_result = { 0, 0 },
    uses_force_mining_productivity_bonus = false,
    quality_affects_mining_radius = true,
    minable = { result = "rabbasca-collector-pylon" },
    graphics_set = { 
      idle_animation = { layers = { { filename = "__rabbasca-assets__/graphics/by-hurricane/conduit-animation-2.png", }, { } } },
      working_visualisations = {{ animation = { tint = { 0.75, 0.2, 0.42 } } }}
    }
  }
}
minelon.energy_usage = "7MW"
minelon.energy_source = {
  type = "burner",
  fuel_inventory_size = 1,
  burnt_inventory_size = 10,
  fuel_categories = { "rabbasca-warp-anomaly" },
}
minelon.placeable_by = { item = "rabbasca-collector-pylon", count = 1 }
minelon.allowed_effects = {"speed", "productivity", "quality"}
minelon.flags = { "placeable-player", "player-creation", "no-automated-item-insertion" }
minelon.custom_tooltip_fields = nil
minelon.collision_box = {{-1.2, -1.2},{1.2, 1.2}}
minelon.selection_box = {{-1.5, -1.5},{1.5, 1.5}}
minelon.collision_mask = {
    layers = { object = true, is_object = true }
}
minelon.tile_buildability_rules = nil

local passive_miner = util.merge {
  data.raw["electric-energy-interface"]["rabbasca-energy-source"],
  {
    name = "rabbasca-anomaly-extractor",
    type = "mining-drill",
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
    show_alert_icon = false
  }
}
passive_miner.icon = nil
passive_miner.icons = Rabbasca.icons({
  { proto = data.raw["assembling-machine"]["rabbasca-warp-stabilizer"] },
  { proto = data.raw["item"]["engine-unit"], scale = 0.4, shift = { 8, 8 } },
})
passive_miner.allowed_effects = { }

local floorion = util.merge {
  data.raw["assembling-machine"]["rabbasca-warp-pylon"],
  {
    name = "rabbasca-stability-pylon",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-3.png",
    enable_logistic_control_behavior = false,
    production_health_effect = {
      not_producing = -0.5 / second,
      producing = 0.1 / second
    },
    max_health = 50,
    graphics_set = { 
      idle_animation = { layers = { { filename = "__rabbasca-assets__/graphics/by-hurricane/conduit-animation-3.png", }, { } } },
      working_visualisations = {{ animation = { tint = { 0.75, 0.2, 0.42 } } }}
    },
    energy_usage = "5MW",
    energy_source = {
      type = "burner",
      fuel_inventory_size = 1,
      burnt_inventory_size = 10,
      fuel_categories = { "rabbasca-warp-anomaly" },
    },
    radius_visualisation_specification = {
      sprite = data.raw["utility-sprites"]["default"].construction_radius_visualization,
      distance = 6,
    },
    show_recipe_icon = false
  }
}
floorion.tile_buildability_rules = {{ 
  area = { {-0.8, -0.8}, {0.8, 0.8} }, 
  colliding_tiles = { layers = { out_of_map = true, is_object = true } },
  remove_on_collision = true
}}
floorion.surface_conditions = { Rabbasca.only_underground(true) }
floorion.resistances = { }
floorion.minable = nil
floorion.placeable_by = { item = "rabbasca-stability-pylon", count = 1 }
floorion.allowed_effects = { }
floorion.flags = { "placeable-player", "player-creation", "not-repairable", "not-deconstructable" }
floorion.custom_tooltip_fields = nil
floorion.crafting_categories = { "rabbasca-flooring" }
floorion.created_effect = {
  type = "direct",
  action_delivery = {
    type = "instant",
    source_effects = {
      type = "script",
      effect_id = "rabbasca_register_floorthing",
    },
  }
}

data:extend {
  stabilizer,
  fuel_access,
  miner_remote,
  lab,
  relicary,
  relicary_access,
  relichunter,
  minelon,
  floorion,
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