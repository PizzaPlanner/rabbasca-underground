local sounds = require("__base__.prototypes.entity.sounds")

local ufo = util.merge {
    data.raw["spider-vehicle"]["spidertron"],
    {
        name = "rabbasca-ufo",
        icon = "__rabbasca-assets__/graphics/recolor/icons/warpotron.png",
        icon_size = 64,
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
ufo.placeable_by = { item = "rabbasca-ufo", count = 1 }
ufo.flags = { "placeable-player", "player-creation", "get-by-unit-number" }
ufo.guns = {
    "warpotron-rocket-launcher",
    "warpotron-submachine-gun",
    -- "warpotron-grenade-launcher", -- TODO
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

local launcher =  {
    type = "gun",
    name = "warpotron-rocket-launcher",
    localised_name = {"item-name.spidertron-rocket-launcher"},
    icon = "__base__/graphics/icons/rocket-launcher.png",
    subgroup = "gun",
    hidden = true,
    auto_recycle = false,
    order = "z[spider]-a[rocket-launcher]",
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "rocket",
      cooldown = 45,
      range = 48,
      projectile_creation_distance = -0.5,
      projectile_center = {0, 0.3},
      projectile_orientation_offset = -0.0625,
      sound = sounds.spidertron_rocket_launcher,
    },
    stack_size = 1
}

local launcher_g =  {
    type = "gun",
    name = "warpotron-grenade-launcher",
    localised_name = {"item-name.spidertron-rocket-launcher"},
    icon = "__base__/graphics/icons/rocket-launcher.png",
    subgroup = "gun",
    hidden = true,
    auto_recycle = false,
    order = "z[spider]-a[rocket-launcher]",
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "grenade",
      cooldown = 72,
      range = 48,
      projectile_creation_distance = -0.5,
      projectile_center = {0, 0.3},
      projectile_orientation_offset = -0.0625,
      sound = sounds.spidertron_rocket_launcher,
    },
    stack_size = 1
}

local smg = {
    type = "gun",
    name = "warpotron-submachine-gun",
    icon = "__base__/graphics/icons/submachine-gun.png",
    subgroup = "gun",
    hidden = true,
    auto_recycle = false,
    order = "a[basic-clips]-b[submachine-gun]",
    attack_parameters =
    {
      type = "projectile",
      ammo_category = "bullet",
      cooldown = 12,
      shell_particle =
      {
        name = "shell-particle",
        direction_deviation = 0.1,
        speed = 0.1,
        speed_deviation = 0.03,
        center = {0, 0.1},
        creation_distance = -0.5,
        starting_frame_speed = 0.4,
        starting_frame_speed_deviation = 0.1
      },
      projectile_creation_distance = 1.125,
      range = 32,
      sound = sounds.submachine_gunshot
    },
    stack_size = 1
}

data:extend {
    ufo, ufo_leg, launcher, launcher_g, smg
}