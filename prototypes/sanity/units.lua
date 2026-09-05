local space_age_sounds = require("__space-age__.prototypes.entity.sounds")

data:extend {
  {
    type = "damage-type",
    name = "rabbasca-psychic"
  }
}

local wriggler = util.merge {
    data.raw["unit"]["small-wriggler-pentapod"],
    {
      icons = Rabbasca.icons({{ icon = "__space-age__/graphics/icons/small-wriggler.png", tint = {0,0,0} }}),
      name = "rabbasca-small-insanity-wriggler",
      flags = { "not-selectable-in-game" },
      max_health = 120,
      healing_per_tick = -2 / second,
      has_belt_immunity = true,
      alert_when_damaged = false,
      order = "r[rabbasca]-u[underground]-a"
    }
}
wriggler.attack_parameters.cooldown = second / 1.85
wriggler.attack_parameters.health_penalty = 5
wriggler.attack_parameters.ammo_category = "seismic"
wriggler.attack_parameters.ammo_type =
{
  target_type = "entity",
  action =
  {
    type = "direct",
    action_delivery =
    {
      type = "instant",
      source_effects =
      {
        {
          type = "damage",
          damage = { amount = 8, type = "electric"}
        },
      },
      target_effects =
      {
        {
          type = "damage",
          damage = { amount = 1, type = "rabbasca-psychic"}
        },
      }
    }
  }
}
wriggler.resistances = {
  { type = "impact", percent = 100 },
  { type = "poison", percent = 100 },
  { type = "physical", percent = 100 },
  { type = "laser", percent = 95 },
  { type = "fire", percent = 30 },
}
wriggler.attack_parameters.animation.layers = {
    wriggler_spritesheet("attack-tint", 19, 0.48, 0.55, { 0.43, 0, 0.16, 0.1 }),
    wriggler_spritesheet("attack-tint", 19, 0.48, 0.65, { 0.32, 0, 0.57, 0.1 }),
    wriggler_spritesheet("attack-shadow", 19, 0.48, 0.25),
}
wriggler.run_animation.layers = {
    wriggler_spritesheet("run-shadow", 21, 0.48, 0.25),
}
wriggler.attack_reaction = nil
wriggler.selection_box = {{0, 0}, {0, 0}}
wriggler.corpse = nil
wriggler.dying_explosion = nil
wriggler.damaged_trigger_effect = nil
wriggler.collision_mask = { layers = { out_of_map = true }, colliding_with_tiles_only = true }

-- copied from space-age/prototypes/factoriopedia-simulations.lua
local make_enemy = function(name, zoom)
  return
    [[
    game.simulation.camera_zoom = ]]..zoom..[[
    game.simulation.camera_position = {0, 0}
    game.surfaces[1].build_checkerboard{{-40, -40}, {40, 40}}

    enemy = game.surfaces[1].create_entity{name = "]]..name..[[", position = {0, 0}}

    step_0 = function()
      if enemy.valid then
          game.simulation.camera_position = {enemy.position.x, enemy.position.y - 0.5}
      end

      script.on_nth_tick(1, function()
          step_0()
      end)
    end

    step_0()
  ]]
end

wriggler.factoriopedia_simulation = { init = make_enemy("rabbasca-small-insanity-wriggler", 1.8)}

-- based off of space-age/prototypes/entity/enemies.lua
local function demolisher_spritesheet(file_name, is_shadow, scale, tint)
  is_shadow = is_shadow or false
  return util.sprite_load("__space-age__/graphics/entity/lavaslug/lavaslug-" .. file_name,
  {
    direction_count = 128,
    dice = 0, -- dicing is incompatible with sprite alpha masking, do not attempt
    draw_as_shadow = is_shadow,
    draw_as_glow = not is_shadow,
    scale = scale,
    multiply_shift = scale * 2,
    -- surface = "vulcanus",
    usage = "enemy",
    tint = tint
  })
end

local crawler_scale = 0.1
local crawler_speed = 15
local crawler_sounds = space_age_sounds.demolisher.small
local function crawler_damage_effect(damage)
  return
    {
      distance_cooldown = 0.1,
      effect =
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 5 * crawler_scale,
          force = "enemy",
          collision_mask = {layers={player=true, train=true, rail=true, transport_belt=true, is_object=true, is_lower_object=true}},
          action_delivery =
          {
            type = "instant",
            target_effects =
            {
              {
                type = "damage",
                damage = { amount = damage, type = "rabbasca-psychic" }
              },
            },
            source_effects =
            {
              {
                type = "damage",
                damage = { amount = damage, type = "rabbasca-psychic" }
              }
            }
          }
        }
      }
    }
end

local function crawler_glow_effect(scale)
  return {
      distance_cooldown = 2,
      effect =
      {
        type = "nested-result",
        action =
        {
          type = "area",
          radius = 5 * scale,
          force = "not-same",
          collision_mask = {layers={player=true, train=true, rail=true, transport_belt=true, is_object=true, is_lower_object=true}},
          action_delivery =
          {
            type = "instant",
            source_effects =
            {
              {
                type = "create-particle",
                repeat_count = 1,
                particle_name = "rabbasca-insanity-crawler-particle-glow",
                offset_deviation = {{0, 0}, {0, 0}},
                initial_height = 0,
                initial_vertical_speed = 0.05,
                initial_vertical_speed_deviation = 0,
                speed_from_center = 0,
                speed_from_center_deviation = 0,
                only_when_visible = true,
                rotate_offsets = true,
              }
            }
          }
        }
      }
    }
end

local crawler = make_demolisher_head("rabbasca-small-insanity-crawler", "r[rabbasca]-u[underground]-b", crawler_scale, 0, 500, -10 / second, crawler_speed, { init = make_enemy("rabbasca-small-insanity-crawler", 1) }, crawler_sounds)
table.insert(crawler.flags, "not-selectable-in-game")
crawler.selection_box = {{0, 0}, {0, 0}}
crawler.corpse = nil
crawler.dying_explosion = nil
-- crawler.collision_mask = { layers = { out_of_map = true }, colliding_with_tiles_only = true } -- cant set: Will dodge character if not colliding with it
crawler.dying_trigger_effect = nil
crawler.revenge_attack_parameters = nil
crawler.attack_parameters = {
  type = "projectile",
  ammo_category = "seismic",
  min_attack_distance = 0,
  cooldown = 12,
  cooldown_deviation = 1,
  range = 3,
  range_mode = "center-to-center",
  damage_modifier = 0,
  ammo_type =
  {
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          {
            type = "create-entity",
            entity_name = "rabbasca-small-insanity-wriggler",
            offset_deviation = {{-2, -2}, {2, 2}},
            probability = 0.44
          },
          {
            type = "create-sticker",
            sticker = "rabbasca-crawler-sticker-debuff"
          },
          {
            type = "damage",
            damage = { amount = 12, type = "rabbasca-psychic" }
          }
        },
        source_effects =
        {
          {
            type = "damage",
            damage = { amount = 25, type = "rabbasca-psychic" }
          }
        }
      }
    }
  }
}
crawler.update_effects =  { crawler_glow_effect(crawler_scale), crawler_damage_effect(1.5) } 
crawler.update_effects_while_enraged = {
    {
      distance_cooldown = 0.1,
      effect =
      {
        type = "create-particle",
        repeat_count = 8,
        particle_name = "rabbasca-insanity-crawler-particle",
        offset_deviation = {{-0.1, -0.1}, {0.1, -0.1}},
        initial_height = 0,
        initial_vertical_speed = 0.05,
        initial_vertical_speed_deviation = 0.02,
        speed_from_center = 0.02 * 1,
        speed_from_center_deviation = 0.01,
        only_when_visible = true,
        rotate_offsets = true
      },
    },
}
crawler.segment_engine = { segments = { } }
crawler.territory_radius = 2
crawler.icon = nil
crawler.icons = Rabbasca.icons({{ proto = data.raw["segmented-unit"]["small-demolisher"], tint = {0,0,0} }})
crawler.turn_radius = 3.7
crawler.patrolling_turn_radius = 5
crawler.enraged_duration = 1 * hour
crawler.vision_distance = 64
crawler.turn_smoothing = 0.85
crawler.patrolling_speed = crawler_speed / 60
crawler.investigating_speed = crawler_speed / 60
crawler.attacking_speed = crawler_speed / 60
crawler.enraged_speed = crawler_speed / 60
crawler.acceleration_rate = crawler_speed / 60 / 60
crawler.alert_when_damaged = false
crawler.attack_reaction = nil
crawler.animation.layers = { 
  demolisher_spritesheet("head-shadow", true, 0.5 * crawler_scale),
}
crawler.resistances = {
  { type = "impact", percent = 100 },
  { type = "poison", percent = 100 },
  { type = "physical", percent = 100 },
  { type = "laser", percent = 80 },
  { type = "electric", percent = 50 },
}

local c_particle = {
  type = "optimized-particle",
  name = "rabbasca-insanity-crawler-particle",
  life_time = 1.7 * second,
  pictures = { layers = {
      demolisher_spritesheet("tail-shadow", true, 0.5 * crawler_scale),
    } 
  }
}
local c_particle_glow = {
  type = "optimized-particle",
  name = "rabbasca-insanity-crawler-particle-glow",
  life_time = 3 * second,
  fade_away_duration = 3 * second,
  vertical_accelecration = 0.002,
  draw_shadow_when_on_ground = false,
  pictures = { layers = {
      wriggler_spritesheet("attack-tint", 19, 0.48, 0.55, { 0.43, 0, 0.16, 0.1 }),
      wriggler_spritesheet("attack-tint", 19, 0.48, 0.65, { 0.32, 0, 0.57, 0.1 }),
    }
  }
}

local snagger = {
  type = "logistic-robot",
  name = "rabbasca-insanity-logistic-robot",
  shadow_idle_with_cargo = table.deepcopy(data.raw["logistic-robot"]["logistic-robot"].shadow_idle_with_cargo),
  shadow_idle = table.deepcopy(data.raw["logistic-robot"]["logistic-robot"].shadow_idle),
  shadow_in_motion_with_cargo = table.deepcopy(data.raw["logistic-robot"]["logistic-robot"].shadow_in_motion_with_cargo),
  shadow_in_motion = table.deepcopy(data.raw["logistic-robot"]["logistic-robot"].shadow_in_motion),
  placeable_by = { item = "rabbasca-insanity-logistic-robot", count = 1 },
  max_payload_size = 20,
  max_payload_size_after_bonus = 100,
  speed_multiplier_when_out_of_energy = 0,
  draw_cargo = true,
  speed = 10 / second,
  max_speed = 100 / second,
  energy_per_tick = "1W",
  -- energy_per_move = "5W",
  max_energy = "60J",
  min_to_charge = 0,
  max_to_charge = 0,
  alert_when_damaged = false,
  subgroup = "enemies",
  order = "r[rabbasca]-u[underground]-l"
}

data:extend { wriggler, crawler, snagger, c_particle, c_particle_glow }