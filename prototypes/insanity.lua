require("sanity.psychosis")
require("sanity.units")
require("sanity.science")
require("sanity.tinfoil-hat")

data:extend {
-- Rabbasca.make_trigger_item({
--   name = "rabbasca-sanity-mote-init",
--   icon = "__rabbasca-assets__/graphics/recolor/icons/sanity-mote.png",
--   icon_size = 76,
--   localised_description = { "item-description.rabbasca-sanity-mote", { "gui-menu.multiplayer" }, { "description.last-user" } },
--   localised_name = { "item-name.rabbasca-sanity-mote" },
--   factoriopedia_alternative = "rabbasca-sanity-mote"
-- }, "rabbasca_on_sanity_mote_init"),
{
  name = "rabbasca-sanity-mote",
  type = "item",
  stack_size = 200,
  icon = "__rabbasca-assets__/graphics/recolor/icons/sanity-mote.png",
  icon_size = 76,
  subgroup = "rabbasca-security",
  order = "x[sanity-restore]",
  localised_description = { "item-description.rabbasca-sanity-mote", { "gui-menu.multiplayer" }, { "description.last-user" } },
  fuel_category = "rabbasca-imagination",
  fuel_value = "800kJ",
  burnt_result = "rabbasca-imaginary-science-pack-precursor",
  spoil_ticks = 1 * minute,
  spoil_result = "rabbasca-psychosis",
  auto_recycle = false,
},
{
  type = "item",
  icons = Rabbasca.icons{{proto = data.raw["item"]["logistic-robot"], tint = {0,0,0}}},
  name = "rabbasca-insanity-logistic-robot",
  flags = { "ignore-spoil-time-modifier" },
  auto_recycle = false,
  -- hidden = true,
  -- hidden_in_factoriopedia = false,
  subgroup = "enemies",
  order = "r[rabbasca]-u[underground]-l",
  weight = 0,
  stack_size = 200,
  spoil_ticks = 2 * second,
  place_result = "rabbasca-insanity-logistic-robot"
},
{
  type = "ammo",
  name = "rabbasca-psychic-magazine",
  icon = "__rabbasca-assets__/graphics/recolor/icons/psychic-magazine.png",
  ammo_category = "bullet",
  ammo_type =
  {
    action =
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        source_effects =
        {
          type = "create-explosion",
          entity_name = "explosion-gunshot"
        },
        target_effects =
        {
          {
            type = "create-entity",
            entity_name = "explosion-hit",
            offsets = {{0, 1}},
            offset_deviation = {{-0.5, -0.5}, {0.5, 0.5}}
          },
          {
            type = "activate-impact",
            deliver_category = "bullet"
          },
          {
            type = "damage",
            damage = {amount = 2, type = "rabbasca-psychic"}
          },
        }
      }
    }
  },
  magazine_size = 100,
  subgroup = "ammo",
  order = "a[basic-clips]-c[uranium-rounds-magazine]",
  stack_size = 5,
  weight = 1*kg
},
}
-- data.raw["item"]["rabbasca-sanity-mote-init"].flags = { "ignore-spoil-time-modifier" }

data:extend {
{
    type = "technology",
    name = "rabbasca-insanity-1",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/insanity.png",
    icon_size = 160,
    prerequisites = { "rabbasca-archives" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-sanity-mote-unlock" },
      { type = "unlock-recipe", recipe = "rabbasca-imaginary-creation-autocraft" },
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge",
        change = 0.25
      },
    },
    research_trigger =
    {
      type = "craft-item",
      item = "rabbasca-psychosis",
    count = 5
    }
  },
  {
    type = "technology",
    name = "rabbasca-insanity-2",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/insanity.png",
    icon_size = 160,
    prerequisites = { "rabbasca-insanity-1" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-imagination-altar" },
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge",
        change = 0.25
      },
    },
    research_trigger =
    {
      type = "craft-item",
      item = "rabbasca-imaginary-science-pack-precursor",
      count = 1
    }
},
{
    type = "recipe",
    name = "rabbasca-imagination-altar",
    enabled = false,
    energy_required = 8,
    allow_productivity = false,
    hide_from_player_crafting = false,
    ingredients = { 
      { type = "item", name = "tungsten-plate", amount = 120 },
      { type = "item", name = "holmium-plate", amount = 666 },
      { type = "item", name = "quantum-processor", amount = 25 },
      { type = "item", name = "beta-carotene-barrel", amount = 666 },
      { type = "item", name = "rabbasca-sanity-mote", amount = 1 },
    },
    results = {
      { type = "item", name = "rabbasca-imagination-altar", amount = 1 },
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
}
