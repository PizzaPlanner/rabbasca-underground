data:extend {
Rabbasca.make_trigger_item({
  name = "rabbasca-sanity-loss",
  icons ={
    { icon =  "__core__/graphics/icons/entity/character.png", icon_size = 64, shift = {6, 0} },
    { icon =  "__base__/graphics/icons/signal/signal-trash-bin.png", icon_size = 64, scale = 0.4, shift = {-6, 3} }
  },
}, "rabbasca_on_sanity_loss"),
Rabbasca.make_trigger_item({
  name = "rabbasca-sanity-mote",
  spoil_ticks = 30 * second,
  icons ={
    { icon =  "__core__/graphics/icons/entity/character.png", icon_size = 64, shift = {6, 0} },
    { icon =  "__base__/graphics/icons/signal/signal-recycle.png", icon_size = 64, scale = 0.4, shift = {-6, 3} }
  },
}, "rabbasca_on_sanity_restore"),
}
data:extend {
{
    type = "technology",
    name = "rabbasca-insanity-1",
    icons = Rabbasca.icons({{proto = data.raw["item"]["rabbasca-sanity-loss"]}}),
    prerequisites = { "rabbasca-archives" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-embrace-insanity" }
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
    --   { type = "unlock-recipe", recipe = "rabbasca-tinfoil-hat" }
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
      { type = "unlock-recipe", recipe = "rabbasca-tinfoil-hat" }
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
        { type = "item", name = "rabbasca-sanity-loss", amount = 1 },
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
  type = "belt-immunity-equipment",
  name = "rabbasca-tinfoil-hat",
  sprite =
  {
    filename = "__base__/graphics/icons/belt-immunity-equipment.png",
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
  take_result = "rabbasca-tinfoil-hat",
  energy_source = { type = "electric", usage_priority = "primary-output" },
  energy_consumption = "1kW",
  categories = {"armor"}
},
util.merge {
    data.raw["unit"]["small-wriggler-pentapod"],
    {
        name = "rabbasca-small-insanity-wriggler",
        healing_per_tick = -5 / second,
        loot = { { type = "item", name = "rabbasca-sanity-mote", amount = 1, independent_probability = 0.22 } },
        has_belt_immunity = true,
    }
}
}