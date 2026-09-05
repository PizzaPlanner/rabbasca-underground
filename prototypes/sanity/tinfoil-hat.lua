data:extend {
  {
    name = "rabbasca-tinfoil-hat",
    type = "technology",
    icon = "__rabbasca-assets__/graphics/recolor/icons/tinfoil-hat.png",
    icon_size = 64,
    prerequisites = { "rabbasca-imaginary-science-pack" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-tinfoil-hat" },
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge",
        change = 0.5
      },
    },
    unit = {
      time = 60,
      count = 1000,
      ingredients = {
        { "space-science-pack",              1 },
        { "military-science-pack",           1 },
        { "utility-science-pack",            1 },
        { "production-science-pack",         1 },
        { "rabbasca-imaginary-science-pack", 1 },
      }
    },
  },
  {
    name = "rabbasca-tinfoil-hat",
    type = "item",
    place_as_equipment_result = "rabbasca-tinfoil-hat",
    icon = "__rabbasca-assets__/graphics/recolor/icons/tinfoil-hat.png",
    icon_size = 64,
    stack_size = 10,
    weight = 1 * kg,
    subgroup = "utility-equipment",
    order = "h[tinfoil-hat]",
  },
  {
    type = "recipe",
    name = "rabbasca-tinfoil-hat",
    enabled = false,
    energy_required = 5,
    allow_productivity = false,
    hide_from_player_crafting = false,
    auto_recycle = false,
    ingredients = {
      { type = "item", name = "carbon-fiber", amount = 1 },
      { type = "item", name = "iron-plate",   amount = 10 },
      { type = "item", name = "rabbasca-rampant-imagination",   amount = 20 },
    },
    results = {
      { type = "item", name = "rabbasca-tinfoil-hat", amount = 1, quality_min = "normal", quality_max = "normal" },
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
      { 1.0, "identity" },
    },
    take_result = "rabbasca-tinfoil-hat",
    energy_source = { type = "electric", usage_priority = "primary-input" }, -- primary-input deactivates equipment completely(?)
    energy_input = "1kW",
    categories = { "armor" }
  },
}
