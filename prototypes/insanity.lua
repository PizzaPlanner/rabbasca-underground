local sanity_settings = require("scripts.sanity")
local space_age_sounds = require("__space-age__.prototypes.entity.sounds")

data:extend {
Rabbasca.make_trigger_item({
  name = "rabbasca-sanity-loss",
  stack_size = 200,
  icons ={
    { icon =  "__space-age__/graphics/technology/health.png", icon_size = 256, shift = {6, 0} },
    { icon =  "__base__/graphics/icons/signal/signal-trash-bin.png", icon_size = 64, scale = 0.4, shift = {-6, 3} }
  },
  custom_tooltip_fields = {
   { name = { "tooltip.rabbasca-sanity-decrease" }, value = { "tooltip-value.rabbasca-sanity-decrease", string.format("%.1f", sanity_settings.DEFAULT_DRAIN * 100)} }
  },
  subgroup = "rabbasca-security",
  order = "x[sanity-loss]",
}, "rabbasca_on_sanity_loss"),
Rabbasca.make_trigger_item({
  name = "rabbasca-sanity-mote",
  hidden_in_factoriopedia = false,
  hidden = false,
  spoil_ticks = 30 * second,
  stack_size = 200,
  custom_tooltip_fields = {
    { name = { "tooltip.rabbasca-sanity-increase" }, value = { "tooltip-value.rabbasca-sanity-increase", string.format("%.1f", sanity_settings.DEFAULT_RESTORE * 100)} }
  },
  icons ={
    { icon =  "__core__/graphics/icons/entity/character.png", icon_size = 64, shift = {6, 0} },
    { icon =  "__base__/graphics/icons/signal/signal-recycle.png", icon_size = 64, scale = 0.4, shift = {-6, 3} }
  },
  subgroup = "rabbasca-security",
  order = "x[sanity-restore]",
}, "rabbasca_on_sanity_restore"),
}
data.raw["item"]["rabbasca-sanity-mote"].flags = { }
data.raw["item"]["rabbasca-sanity-loss"].flags = { "ignore-spoil-time-modifier" }
data:extend {
{
    type = "technology",
    name = "rabbasca-insanity-1",
    icons = Rabbasca.icons({
      {proto = data.raw["item"]["rabbasca-sanity-loss"]}
    }),
    prerequisites = { "rabbasca-archives" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-embrace-insanity" },
      { type = "unlock-recipe", recipe = "rabbasca-sanity-mote", hidden = true },
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge",
        change = 0.25
      },
    },
    research_trigger =
    {
      type = "craft-item",
      item = "rabbasca-sanity-loss",
      count = 2
    }
  },
  {
    type = "technology",
    name = "rabbasca-insanity-2",
    icons = Rabbasca.icons({{proto = data.raw["item"]["rabbasca-sanity-loss"]}}),
    prerequisites = { "rabbasca-insanity-1" },
    effects = {
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge",
        change = 0.25
      },
    },
    research_trigger =
    {
      type = "craft-item",
      item = "rabbasca-sanity-loss",
      count = 100
    }
},
  {
    type = "technology",
    name = "rabbasca-insanity-3",
    icons = Rabbasca.icons({{proto = data.raw["item"]["rabbasca-sanity-loss"]}}),
    prerequisites = { "rabbasca-insanity-2" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-tinfoil-hat" },
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge",
        change = 0.5
      },
    },
    research_trigger =
    {
      type = "craft-item",
      item = "rabbasca-sanity-loss",
      count = 1000
    }
},
{
        type = "recipe",
        name = "rabbasca-sanity-mote",  -- for signal unlock
        enabled = false,
        hidden = true,
        hidden_in_factoriopedia = true,
        hide_from_player_crafting = true,
        requires_ingredients_to_unlock_results = false,
        energy_required = 0.5,
        allow_productivity = false,
        auto_recycle = false,
        ingredients = {
            { type = "item", name = "rabbasca-sanity-loss", amount = 1 },
        },
        results = { 
            { type = "item", name = "rabbasca-sanity-mote", amount = 1, always_fresh = true },
        },
        categories = { "parameters" }
    },
    {
    type = "recipe",
    name = "rabbasca-embrace-insanity",
    auto_recycle = false,
    enabled = false,
    energy_required = 0.5,
    allow_productivity = false,
    hide_from_player_crafting = false,
    ingredients = {
        { type = "item", name = "rabbasca-sanity-mote", amount = 1 },
    },
    results = {
        { type = "item", name = "rabbasca-sanity-loss", amount = 1, always_fresh = true },
    },
    categories = { "crafting" }
},
{
    type = "recipe",
    name = "rabbasca-tinfoil-hat",
    enabled = false,
    energy_required = 5,
    allow_productivity = false,
    hide_from_player_crafting = false,
    ingredients = { 
      { type = "item", name = "carbon-fiber", amount = 1 },
      { type = "item", name = "iron-plate", amount = 10 },
    },
    results = {
      { type = "item", name = "rabbasca-tinfoil-hat", amount = 1 },
    },
    categories = { "crafting" }
},
{
  type = "night-vision-equipment",
  name = "rabbasca-tinfoil-hat",
  sprite =
  {
    filename = "__rabbasca-assets__/graphics/recolor/icons/tinfoil-hat.png",
    flags = { "icon" },
    size = 64,
    priority = "extra-high-no-scale",
    scale = 0.5
  },
  shape =
  {
    width = 1,
    height = 1,
    type = "full"
  },
  darkness_to_turn_on = 0,
  color_lookup = {
    {1.0, "identity"},
  },
  take_result = "rabbasca-tinfoil-hat",
  energy_source = { type = "electric", usage_priority = "primary-input" }, -- primary-input deactivates equipment completely(?)
  energy_input = "1kW",
  categories = {"armor"}
},
}

data:extend {
  {
    type = "damage-type",
    name = "rabbasca-psychic"
  }
}

data:extend{
{
  type = "sticker",
  name = "rabbasca-insanity-sticker-debuff",
  duration_in_ticks = sanity_settings.DEFAULT_CHECK_INTERVAL + 1,
  -- force_visibility = "ally",
  render_layer = "air-object",
  flags = {"not-on-map"},
  hidden = true,
  single_particle = true,
  animation = {
    layers = { 
      Rabbasca.animation_layer("__rabbasca-assets__/graphics/recolor/textures/sani", { tint = { 0.83, 0, 0.72 }, scale = 0.16, draw_as_glow = true, blend_mode = "additive", shift = util.by_pixel(-8,-54) }),
      Rabbasca.animation_layer("__rabbasca-assets__/graphics/recolor/textures/sani", { tint = { 0.33, 0, 1 },    scale = 0.14, draw_as_glow = true, blend_mode = "additive", shift = util.by_pixel(8,-56), frame_sequence = { 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 } })
    }
  },
  update_effects = {
    { 
      time_cooldown = sanity_settings.DEFAULT_BUFF_INTERVAL,
      initial_time_cooldown = 240,
      effect = {
        type = "script",
        effect_id = "rabbasca_on_insanity_tick",
      }
    }
  }
},
{
  type = "sticker",
  name = "rabbasca-crawler-sticker-debuff",
  duration_in_ticks = 5 * second,
  target_movement_modifier_from = 0.33,
  target_movement_modifier_to = 1,
  ground_target = true,
  flags = {"not-on-map"},
  hidden = true,
  single_particle = true,
  animation =
    util.sprite_load("__space-age__/graphics/sticker/jellynut-speed/whirl_front",
      {
        priority = "high",
        frame_count = 50,
        scale = 0.5,
        animation_speed = 0.5,
        tint = { 1, 0, 0.3 },
        shift = util.by_pixel(0,16)
      }
    )
}
}
data:extend{ util.merge { data.raw["sticker"]["rabbasca-insanity-sticker-debuff"], { name = "rabbasca-insanity-sticker-buff", animation = { layers = { { tint = { 0, 0.83, 0.77 } },{} }} } } }

local wriggler = util.merge {
    data.raw["unit"]["small-wriggler-pentapod"],
    {
      icons = Rabbasca.icons({{ icon = "__space-age__/graphics/icons/small-wriggler.png", tint = {0,0,0} }}),
      name = "rabbasca-small-insanity-wriggler",
      flags = { "not-selectable-in-game" },
      healing_per_tick = -1 / second,
      has_belt_immunity = true,
      alert_when_damaged = false,
      order = "r[rabbasca]-u[underground]-a"
    }
}
wriggler.attack_parameters.cooldown = second / 1.85
wriggler.attack_parameters.health_penalty = 5
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
wriggler.attack_reaction =
{
  {
    range = 30,
    reaction_modifier = 0,
    action =
    {
      type = "direct",
      probability = 0.02,
      force = "not-same",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "insert-item",
          -- always use at least 0.1 damage
          item = "rabbasca-sanity-mote"
        }
      }
    },
  }
}
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
          force = "not-same",
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
-- crawler.collision_mask = { layers = { out_of_map = true }, colliding_with_tiles_only = true }
crawler.dying_trigger_effect = nil
crawler.revenge_attack_parameters = {
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
crawler.attack_reaction =
{
  {
    range = 30,
    reaction_modifier = 0,
    action =
    {
      type = "direct",
      probability = 0.12,
      force = "not-same",
      action_delivery =
      {
        type = "instant",
        target_effects =
        {
          type = "insert-item",
          item = "rabbasca-sanity-mote"
        }
      }
    },
  }
}
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

data:extend { wriggler, crawler, c_particle, c_particle_glow }