require("sanity.psychosis")
require("sanity.units")
require("sanity.science")
require("sanity.tinfoil-hat")
require("sanity.hellvent")
data:extend {
{
  name = "rabbasca-rampant-imagination",
  type = "item",
  stack_size = 200,
  icon = "__rabbasca-assets__/graphics/recolor/icons/sanity-mote.png",
  icon_size = 76,
  flags = { "excluded-from-trash-unrequested", "excluded-from-character-lift-weight" },
  subgroup = "rabbasca-security",
  order = "x[sanity-restore]",
  localised_description = { "item-description.rabbasca-rampant-imagination", { "gui-menu.multiplayer" }, { "description.last-user" } },
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
