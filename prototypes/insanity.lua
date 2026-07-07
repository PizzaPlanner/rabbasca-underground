local sanity_settings = require("scripts.sanity")
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
      count = 2000
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

local wriggler = util.merge {
    data.raw["unit"]["small-wriggler-pentapod"],
    {
        name = "rabbasca-small-insanity-wriggler",
        healing_per_tick = -10 / second,
        has_belt_immunity = true,
        alert_when_damaged = false,
    }
}

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
          damage = { amount = -20, type = "electric"}
        },
        {
          type = "damage",
          damage = { amount = 500, type = "electric"},
          probability = 0.01, vaporize = true
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
  { type = "fire", percent = 30 },
}
wriggler.attack_parameters.animation.layers = {
    wriggler_spritesheet("attack-tint", 19, 0.48, 0.25, { 0.32, 0, 0.57, 0.5 }),
    wriggler_spritesheet("attack-tint", 19, 0.48, 0.55, { 0.43, 0, 0.16, 0.1 }),
    wriggler_spritesheet("attack-tint", 19, 0.48, 0.65, { 0.32, 0, 0.57, 0.1 }),
    wriggler_spritesheet("attack-shadow", 19, 0.48, 0.25),
}
wriggler.run_animation.layers = {
    wriggler_spritesheet("run-tint", 21, 0.48, 0.25, { 0.38, 0, 0.57, 0.5 }),
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
      probability = 0.1,
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
wriggler.corpse = nil
wriggler.dying_explosion = nil
wriggler.collision_mask = { layers = { out_of_map = true }, colliding_with_tiles_only = true }

data:extend { wriggler }