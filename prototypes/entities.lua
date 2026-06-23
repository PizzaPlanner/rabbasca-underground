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
            burnt_inventory_size = 100,
            initial_fuel         = "rabbasca-warp-cell-internal-big",
            initial_fuel_percent = 0.001,
            fuel_categories      = { "rabbasca-warp-anomaly" },
        },
        module_slots = 20,
        trash_inventory_size = 10,
        hidden = false,
        hidden_in_factoriopedia = false,
        tall = true,
        subgroup = "rabbasca-warp-stabilizer",
        order = "a[stabilizer]",
    } }
stabilizer.effect_receiver = {
    -- base_effect = { consumption = 4 },
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
stabilizer.next_upgrade = nil
stabilizer.deconstruction_alternative = nil
stabilizer.crafting_categories = { "rabbasca-warp-stabilizer" }
stabilizer.autoplace = { probability_expression = "0" }
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
    subgroup = "rabbasca-warp-stabilizer",
    order = "a[stabilizer]-c[relichunter]",
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
    icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
    type = "furnace",
    max_health = 100,
    -- production_health_effect = {
    --   producing = -8 / second,
    --   not_producing = 0
    -- },
    flags = { "placeable-neutral", "not-repairable", "not-deconstructable", "no-logistic-connection" },
    collision_box = { { -0.9, -0.9 }, { 0.9, 0.9 } },
    selection_box = { { -1, -1 }, { 1, 1 } },
    result_inventory_size = 10,
    source_inventory_size = 1,
    crafting_speed = 1,
    energy_usage = "10W",
    energy_source = {
        type = "burner",
        burner_usage = "fuel",
        effectivity = 1,
        fuel_categories = { "rabbasca-relicary" },
        initial_fuel = "rabbasca-powerspike",
        initial_fuel_percent = 0.1,
        fuel_inventory_size = 1,
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
    collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    surface_conditions = { Rabbasca.only_underground(true) }
}

local miner_remote = {
    name = "rabbasca-miner-remote",
    hidden = true,
    icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
    type = "proxy-container",
    flags = { "placeable-player", "not-selectable-in-game", "not-on-map", "not-deconstructable", "no-automated-item-removal", "not-blueprintable" },
    draw_inventory_content = false,
    max_health = 100,
    collision_box = { { -0.2, -0.2 }, { 0.2, 0.2 } },
    -- selection_box = {{-0.5, -0.5},{0.5, 0.5}},
    surface_conditions = { Rabbasca.only_underground(true) },
    collision_mask = {
        layers = {},
        colliding_with_tiles_only = true
    },
}

local fuel_access = {
    name = "rabbasca-fuel-remote",
    icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
    type = "container",
    inventory_type = "with_filters_and_bar",
    inventory_size = 1,
    circuit_wire_max_distance = 90,
    minable = { result = "rabbasca-fuel-remote", count = 1, mining_time = 1 },
    placeable_by = { item = "rabbasca-fuel-remote", count = 1 },
    flags = { "placeable-player", "player-creation" },
    next_upgrade = nil,
    deconstruction_alternative = nil,
    draw_inventory_content = true,
    max_health = 100,
    picture = table.deepcopy(data.raw["linked-container"]["linked-chest"].picture),
    collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    surface_conditions = { Rabbasca.only_underground(true) },
    created_effect = {
        type = "direct",
        action_delivery = {
            type = "instant",
            source_effects = {
                {
                    type = "script",
                    effect_id = "rabbasca_register_fuel_remote",
                },
            }
        }
    }
}

local fuel_access_2 = util.merge {
    fuel_access,
    {
        name = "rabbasca-fuel-remote-big",
        max_health = 500,
        inventory_size = 9,
        collision_box = { { -0.8, -0.8 }, { 0.8, 0.8 } },
        selection_box = { { -1, -1 }, { 1, 1 } },
    }
}
fuel_access_2.placeable_by = nil
fuel_access_2.minable = nil

local minelon = util.merge {
    data.raw["assembling-machine"]["rabbasca-warp-pylon"],
    {
        name = "rabbasca-collector-pylon",
        type = "mining-drill",
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
        subgroup = data.raw["item"]["rabbasca-warp-pylon"].subgroup,
        order = data.raw["item"]["rabbasca-warp-pylon"].order .. "-r[rabbasca-underground]",
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
                filename = "__base__/graphics/entity/centrifuge/centrifuge-ABC-shadow.png",
                width = 2232 / 8,
                height = 1216 / 8,
                draw_as_shadow = true,
                shift = { 0.6, -0.4 },
            } },
        }
    },
    always_draw_idle_animation = true
}
minelon.energy_usage = "3MW"
minelon.energy_source = {
    type = "burner",
    fuel_inventory_size = 0,
    burnt_inventory_size = 0,
    initial_fuel = "rabbasca-warp-cell-internal",
    initial_fuel_percent = 0.001,
    fuel_categories = { "rabbasca-warp-anomaly" },
}
minelon.placeable_by = { item = "rabbasca-collector-pylon", count = 1 }
minelon.minable = nil
minelon.allowed_effects = { "speed", "productivity" }
minelon.flags = { "placeable-player", "player-creation", "no-automated-item-insertion", "get-by-unit-number" }
minelon.custom_tooltip_fields = nil
minelon.collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } }
minelon.selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } }
-- minelon.collision_mask = {
--     layers = { is_object = true }
-- }
-- minelon.tile_buildability_rules = nil
minelon.created_effect = {
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

local floorion = util.merge {
    data.raw["assembling-machine"]["rabbasca-warp-pylon"],
    {
        name = "rabbasca-stability-pylon",
        icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-3.png",
        production_health_effect = {
            not_producing = -0.5 / second,
            producing = 0.25 / second
        },
        max_health = 50,
        graphics_set = {
            idle_animation = { layers = { { filename = "__rabbasca-assets__/graphics/by-hurricane/conduit-animation-3.png", }, {} } },
            working_visualisations = { { animation = { tint = { 0.75, 0.2, 0.42 } } } }
        },
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
    }
}
floorion.tile_buildability_rules = { {
    area = { { -0.8, -0.8 }, { 0.8, 0.8 } },
    colliding_tiles = { layers = { out_of_map = true, is_object = true } },
    remove_on_collision = true
} }
floorion.surface_conditions = { Rabbasca.only_underground(true) }
floorion.resistances = {}
floorion.minable = nil
floorion.placeable_by = nil
floorion.allowed_effects = {}
floorion.flags = { "placeable-player", "player-creation", "not-repairable", "not-deconstructable", "get-by-unit-number", "no-logistic-connection" }
floorion.custom_tooltip_fields = nil
floorion.crafting_categories = { "rabbasca-flooring" }
floorion.created_effect = {
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
}

local ufo = util.merge {
    data.raw["spider-vehicle"]["spidertron"],
    {
        name = "rabbasca-ufo",
        icon = "__rabbasca-assets__/graphics/recolor/icons/warpotron.png",
        movement_energy_consumption = "9MW",
        has_belt_immunity = true,
        inventory_size = 20,
        trash_inventory_size = 20,
        allow_remote_driving = true,
        torso_rotation_speed = 0.05,
        torso_bob_speed = 0.07,
        radar_range = 3,
        height = 2,
        allow_passengers = true,
        energy_source = {
            type                 = "burner",
            fuel_inventory_size  = 0,
            burnt_inventory_size = 0,
            initial_fuel         = "rabbasca-warp-cell-internal",
            initial_fuel_percent = 0.001,
            fuel_categories      = { "rabbasca-warp-anomaly" },
        },
    }
}
ufo.minable = { result = "rabbasca-ufo", count = 1, mining_time = 1 }
-- ufo.placeable_by = { item = "rabbasca-ufo", count = 1 }
ufo.flags = { "placeable-player", "player-creation", "get-by-unit-number" }
ufo.guns = {
    "teslagun",
    "teslagun",
    "teslagun",
}
ufo.collision_mask = {
    layers = { out_of_map = true },
    collides_with_tiles_only = true
}
ufo.created_effect = {
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
}
ufo.spider_engine.legs = { leg = "rabbasca-ufo-leg", mount_position = { 0, 0 }, ground_position = { 0, 0 }, walking_group = 1 }
local ufo_leg = util.merge {
    data.raw["spider-leg"]["spidertron-leg-1"],
    {
        name = "rabbasca-ufo-leg",
        initial_movement_speed = 1.8,
        movement_acceleration = 3,
        target_position_randomisation_distance = 0,
    }
}
ufo_leg.collision_mask = table.deepcopy(ufo.collision_mask)
ufo_leg.graphics_set = nil

data:extend {
    stabilizer,
    ufo, ufo_leg,
    fuel_access, fuel_access_2,
    relicary,
    relicary_access,
    relichunter,
    minelon, miner_remote,
    floorion,
}
