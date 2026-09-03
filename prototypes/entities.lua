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
        collision_box = { { -3.7, -3.7 }, { 3.7, 3.7 } },
        selection_box = { { -4, -4 }, { 4, 4 } },
        energy_usage = "1W",
        energy_source = {
            type                 = "burner",
            fuel_inventory_size  = 0,
            burnt_inventory_size = 0,
            initial_fuel         = "rabbasca-warp-cell-internal-big",
            initial_fuel_percent = 0.001,
            fuel_categories      = { "rabbasca-warp-anomaly" },
        },
        module_slots = 10,
        trash_inventory_size = 20,
        hidden = false,
        hidden_in_factoriopedia = false,
        tall = true,
        selection_priority = 51, -- prio over safe collectors
        subgroup = "rabbasca-warp-stabilizer",
        order = "a[stabilizer]",
    } }
stabilizer.effect_receiver = {
    -- base_effect = { consumption = 4 },
    uses_module_effects = true,
    uses_beacon_effects = false,
    uses_surface_effects = false
}
stabilizer.resistances = {
    { type = "rabbasca-psychic", percent = 100 }
}
stabilizer.circuit_wire_max_distance = 120
stabilizer.ignore_output_full = false
stabilizer.minable = nil
stabilizer.placeable_by = nil
stabilizer.allowed_effects = { "speed", "consumption", "pollution" }
stabilizer.flags = { "placeable-player", "player-creation" }
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
    animation = {
        layers = {
            util.merge { sprite_data, { filename = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-animation.png" } },
            util.merge { sprite_data, { filename = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-shadow.png", width = 900, height = 500, frame_count = 1, repeat_count = 80, line_length = 1, draw_as_shadow = true } },
        }
    },
    working_visualisations = {
        {
            fadeout = true,
            animation = util.merge { sprite_data,
                { filename = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-emission1.png", draw_as_glow = true, blend_mode = "additive", apply_runtime_tint = true } },
            apply_recipe_tint = "primary"
        },
        {
            fadeout = true,
            animation = util.merge { sprite_data,
                { filename = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-emission2.png", draw_as_glow = true, blend_mode = "additive" } },
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
    flags = { "placeable-player", "player-creation", "get-by-unit-number" },
    max_health = 250,
    production_health_effect = {
      not_producing = -0.1 / hour, -- required to resume crafting after running out of fuel and being refuelled
      producing = 1 / second
    },
    circuit_wire_max_distance = 90,
    collision_box = { { -1.8, -1.8 }, { 1.8, 1.8 } },
    selection_box = { { -2, -2 }, { 2, 2 } },
    crafting_speed = 1,
    module_slots = 0,
    placeable_by = { item = "rabbasca-relichunter", count = 1 },
    minable = { result = "rabbasca-relichunter", count = 1, mining_time = 1 },
    crafting_categories = { "rabbasca-relichunter" },
    energy_usage = "8MW",
    energy_source = {
        type                 = "burner",
        fuel_inventory_size  = 0,
        burnt_inventory_size = 0,
        initial_fuel         = "rabbasca-warp-cell-internal",
        initial_fuel_percent = 0.001,
        fuel_categories      = { "rabbasca-warp-anomaly" },
    },
    hidden = false,
    hidden_in_factoriopedia = false,
    subgroup = "rabbasca-ug-processes",
    order = "h[hunter]",
    created_effect = {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                {
                    type = "script",
                    effect_id = "rabbasca_register_fuel_consumer",
                },
            }
        },
    },
    graphics_set = {
        animation = {
            layers = {
                util.merge { rh_spritedata, { filename = "__rabbasca-assets__/graphics/by-hurricane/research-center-animation.png" } },
                util.merge { rh_spritedata, { filename = "__rabbasca-assets__/graphics/by-hurricane/research-center-hr-shadow.png", width = 1200, height = 700, frame_count = 1, repeat_count = 80, line_length = 1, draw_as_shadow = true } },
            }
        },
        working_visualisations = {
            {
                fadeout = true,
                animation = util.merge { rh_spritedata,
                    { filename = "__rabbasca-assets__/graphics/by-hurricane/research-center-emission1.png", draw_as_glow = true, blend_mode = "additive" } },
            },
            {
                fadeout = true,
                animation = util.merge { rh_spritedata,
                    { filename = "__rabbasca-assets__/graphics/by-hurricane/research-center-emission2.png", draw_as_glow = true, blend_mode = "additive" } },
            },
        },
    }
}

local relicary = {
    name = "rabbasca-relicary",
    icon = "__rabbasca-assets__/graphics/icons/archive.png",
    icon_size = 128,
    type = "furnace",
    max_health = 25000,
    -- production_health_effect = {
    --   producing = -8 / second,
    --   not_producing = 0
    -- },
    flags = { "placeable-neutral", "not-repairable", "not-deconstructable", "no-logistic-connection" },
    collision_box = { { -1.4, -1.4 }, { 1.4, 1.4 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    result_inventory_size = 10,
    source_inventory_size = 1,
    crafting_speed = 1,
    energy_usage = "10W",
    energy_source = {
        type = "burner",
        burner_usage = "fuel",
        effectivity = 1,
        fuel_categories = { "rabbasca-relicary" },
        initial_fuel = "rabbasca-powershard",
        initial_fuel_percent = 0.1,
        fuel_inventory_size = 1,
        light_flicker = { },
    },
    module_slots = 0,
    crafting_categories = { "rabbasca-relics" },
    surface_conditions = { Rabbasca.only_underground(true) },
    -- cant_insert_at_source_message_key = "inventory-restriction.not-a-vault-key",
    graphics_set = { 
        working_visualisations = { {
            fadeout = true, 
            animation = Rabbasca.animation_layer("__rabbasca-assets__/graphics/entities/archive/emission", { scale = 0.7, draw_as_glow = true, blend_mode = "additive" }),
        } },
        idle_animation = { layers = { 
            Rabbasca.animation_layer("__rabbasca-assets__/graphics/entities/archive/base", { scale = 0.7 }),
            Rabbasca.animation_layer("__rabbasca-assets__/graphics/entities/archive/shadow", { draw_as_shadow = true, scale = 0.7 }),
        } },
        always_draw_idle_animation = true 
    },
    subgroup = "rabbasca-warp-stabilizer",
    order = "h[hunter]-b[relicary]"
}

local relicary_access = {
    name = "rabbasca-relicary-remote",
    icons = Rabbasca.icons({{proto = data.raw["item"]["rabbasca-relicary-remote"]}}),
    type = "proxy-container",
    flags = { "placeable-player", "player-creation" },
    placeable_by = { item = "rabbasca-relicary-remote", count = 1 },
    minable = { result = "rabbasca-relicary-remote", count = 1, mining_time = 1 },
    draw_inventory_content = true,
    max_health = 100,
    circuit_wire_max_distance = 90,
    picture = table.deepcopy(data.raw["linked-container"]["linked-chest"].picture),
    collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    surface_conditions = { Rabbasca.only_underground(true) },
}

local miner_remote = {
    name = "rabbasca-miner-remote",
    hidden = true,
    icons = Rabbasca.icons({{ proto = data.raw["item"]["no-item"] }}),
    type = "proxy-container",
    flags = { "placeable-player", "not-selectable-in-game", "not-on-map", "not-deconstructable", "no-automated-item-removal", "not-blueprintable" },
    draw_inventory_content = false,
    max_health = 100,
    collision_box = { { -0.2, -0.2 }, { 0.2, 0.2 } },
    surface_conditions = { Rabbasca.only_underground(true) },
    collision_mask = {
        layers = {},
        colliding_with_tiles_only = true
    },
}

local anomaly_storage = {
    type = "container",
    name = "rabbasca-anomaly-storage",
    icon = "__rabbasca-assets__/graphics/recolor/icons/nearby-access.png",
    icon_size = 64,
    circuit_wire_max_distance = 90,
    flags = { "placeable-player", "player-creation" },
    next_upgrade = nil,
    deconstruction_alternative = nil,
    draw_inventory_content = true,
    max_health = 500,
    inventory_size = 9,
    picture = table.deepcopy(data.raw["linked-container"]["linked-chest"].picture),
    collision_box = { { -0.8, -0.8 }, { 0.8, 0.8 } },
    selection_box = { { -1, -1 }, { 1, 1 } },
    surface_conditions = { Rabbasca.only_underground(true) },
    resistances = {
        { type = "rabbasca-psychic", percent = 100 }
    }
}
anomaly_storage.picture.layers[1].filename = "__rabbasca-assets__/graphics/recolor/entities/anomaly-access.png"
for _, layer in pairs(anomaly_storage.picture.layers) do
    layer.scale = (layer.scale or 1) * 2
end

local minelon = {
    name = "rabbasca-collector-pylon",
    type = "mining-drill",
    max_health = 1000,
    icon = "__rabbasca-assets__/graphics/recolor/icons/cpylon.png",
    hidden_in_factoriopedia = false,
    resource_searching_radius = 1.5,
    shuffle_resources_to_mine = false,
    require_resources_to_place = false,
    mining_speed = 4,
    resource_categories = { "rabbasca-warp-anomaly" },
    vector_to_place_result = { 0, 0 },
    uses_force_mining_productivity_bonus = false,
    quality_affects_mining_radius = false,
    resistances = {
        { type = "rabbasca-psychic", percent = 100 }
    },
    energy_usage = "3MW",
    energy_source = {
        type = "burner",
        fuel_inventory_size = 0,
        burnt_inventory_size = 0,
        initial_fuel = "rabbasca-warp-cell-internal",
        initial_fuel_percent = 0.001,
        fuel_categories = { "rabbasca-warp-anomaly" },
    },
    surface_conditions = { Rabbasca.only_underground(true) },
    placeable_by = { item = "rabbasca-collector-pylon", count = 1 },
    allowed_effects = { "speed", "productivity" },
    flags = { "placeable-player", "player-creation", "no-automated-item-insertion", "get-by-unit-number" },
    collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    collision_mask = {
        layers = { is_object = true, out_of_map = true }
    },
    created_effect = {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                {
                    type = "script",
                    effect_id = "rabbasca_register_anomaly_miner",
                },
                {
                    type = "script",
                    effect_id = "rabbasca_register_fuel_consumer",
                },
            }
        }
    }
}
local anim = {
    frame_count = 64,
    line_length = 8,
    scale = 0.6,
    shift = { 0, -1 },
}
minelon.graphics_set = {
    working_visualisations = { {
        animation = util.merge { anim, {
            filename = "__rabbasca-assets__/graphics/recolor/entities/centrifuge-C-light.png",
            draw_as_glow = true,
            width = 1520 / 8,
            height = 1656 / 8,
            blend_mode = "additive-soft",
            tint = { 0.23, 0.11, 1 }
        } },
        apply_recipe_tint = "primary"
    } },
    default_recipe_tint = { primary = { 0.5, 1, 0 } },
    idle_animation = {
        layers = {
            util.merge { anim, {
                filename = "__rabbasca-assets__/graphics/recolor/entities/centrifuge-C.png",
                width = 1896 / 8,
                height = 1712 / 8,
            } },
            util.merge { anim, {
                filename = "__rabbasca-assets__/graphics/recolor/entities/centrifuge-C-shadow.png",
                width = 2232 / 8,
                height = 1216 / 8,
                draw_as_shadow = true,
                shift = { 0.6, -0.4 },
            } },
        }
    },
    always_draw_idle_animation = true
}

local floorion = {
    type = "assembling-machine",
    name = "rabbasca-stability-pylon",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-3.png",
    production_health_effect = {
        not_producing = -0.5 / second,
        producing = 0.25 / second
    },
    max_health = 50,
    energy_usage = "2MW",
    energy_source = {
        type                 = "burner",
        fuel_inventory_size  = 0,
        burnt_inventory_size = 0,
        initial_fuel         = "rabbasca-warp-cell-internal",
        initial_fuel_percent = 0.001,
        fuel_categories      = { "rabbasca-warp-anomaly" },
    },
    radius_visualisation_specification = {
        sprite = data.raw["utility-sprites"]["default"].construction_radius_visualization,
        distance = 6,
    },
    show_recipe_icon = false,
    trash_inventory_size = 2,
    crafting_speed = 1,
    collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selection_box = {{-1, -1}, {1, 1}},
    tile_buildability_rules = { {
        area = { { -0.8, -0.8 }, { 0.8, 0.8 } },
        colliding_tiles = { layers = { out_of_map = true, is_object = true } },
        remove_on_collision = true
    } },
    surface_conditions = { Rabbasca.only_underground(true) },
    collision_mask = {
        layers = { is_object = true, out_of_map = true }
    },
    resistances = {
        { type = "rabbasca-psychic", percent = 100 }
    },
    minable = nil,
    placeable_by = { item = "rabbasca-stability-pylon", count = 1 },
    allowed_effects = {},
    flags = { "placeable-player", "player-creation", "not-repairable", "not-deconstructable", "get-by-unit-number", "no-logistic-connection" },
    custom_tooltip_fields = nil,
    crafting_categories = { "rabbasca-flooring" },
    created_effect = {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                {
                    type = "script",
                    effect_id = "rabbasca_register_floorthing",
                },
                {
                    type = "script",
                    effect_id = "rabbasca_register_fuel_consumer",
                },
            }
        }
    },
    graphics_set = {
        working_visualisations = {{
        animation = {
              filename = "__rabbasca-assets__/graphics/by-hurricane/conduit-emission.png",
              frame_count = 60,
              line_length = 10,
              width = 200,
              height = 290,
              draw_as_glow = true,
              blend_mode = "additive-soft",
              scale = 1.0/3,
              shift = {0, -0.5},
              apply_runtime_tint = true,
              tint = { 0.75, 0.2, 0.42 }
        },
        apply_recipe_tint = "primary"
      }},
      default_recipe_tint = { primary = {0.5, 1, 0} },
      idle_animation = {
        layers = {
          {
            filename = "__rabbasca-assets__/graphics/by-hurricane/conduit-animation-3.png",
            frame_count = 60,
            line_length = 10,
            width = 200,
            height = 290,
            scale = 1.0/3,
            flags = {"no-scale"},
            shift = {0, -0.5},
          },
          {
              filename = "__rabbasca-assets__/graphics/by-hurricane/conduit-hr-shadow.png",
              repeat_count = 60,
              width = 600,
              height = 400,
              scale = 1.0/3,
              draw_as_shadow = true,
              shift = {0, -0.5},
          },
        }
      },
      always_draw_idle_animation = true
    },
}

data:extend {
    stabilizer,
    anomaly_storage,
    relicary,
    relicary_access,
    relichunter,
    minelon, miner_remote,
    floorion,
}

local function make_warp_cell_with_indicator(entity)
  local cell =  util.merge {
    data.raw["item-with-inventory"]["rabbasca-warp-cell"],
    {
        name = "rabbasca-warp-cell-indicator-"..entity.name,
        localised_name = { "item-name.rabbasca-warp-cell" },
        localised_description = { "item-description.rabbasca-warp-cell" },
        factoriopedia_alternative = "rabbasca-warp-cell",
        hidden_in_factoriopedia = true,
        hidden = true,
    }
  }
  cell.icon = nil
  cell.icons = Rabbasca.icons({
    { proto = data.raw["item-with-inventory"]["rabbasca-warp-cell"] },
    { proto = entity, scale = 0.5, shift = { 8, 8 } }
  })
  return cell
end

data:extend{
  make_warp_cell_with_indicator(data.raw["assembling-machine"]["rabbasca-relichunter"]),
  make_warp_cell_with_indicator(data.raw["assembling-machine"]["rabbasca-stability-pylon"]),
  make_warp_cell_with_indicator(data.raw["mining-drill"]["rabbasca-collector-pylon"]),
  make_warp_cell_with_indicator(data.raw["spider-vehicle"]["rabbasca-ufo"])
}