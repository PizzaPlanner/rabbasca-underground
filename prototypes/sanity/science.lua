data:extend {
{
  type = "item",
  name = "rabbasca-contained-imagination",
  icon = "__rabbasca-assets__/graphics/recolor/icons/imaginary-science-pack-precursor.png",
  icon_size = 64,
  auto_recycle = false,
  weight = 1 * kg,
  stack_size = 200,
  subgroup = "science-pack",
  order = "k-r[rabbasca]-2",
  spoil_ticks = 1 * hour,
  spoil_result = "rabbasca-psychosis",
  destroyed_by_dropping_trigger = data.raw["item"]["rabbasca-psychosis"].spoil_to_trigger_result.trigger,
},
util.merge {
  data.raw["item"]["automation-science-pack"],
  {
    name = "rabbasca-imaginary-science-pack",
    icon = "__rabbasca-assets__/graphics/recolor/icons/imaginary-science-pack.png",
    icon_size = 64,
    auto_recycle = false,
    localised_description = { "item-description.rabbasca-imaginary-science-pack" },
    subgroup = "science-pack",
    order = "k-r[rabbasca]-2",
    weight = 1 * kg,
    spoil_ticks = 3 * minute,
    spoil_result = "rabbasca-psychosis",
    destroyed_by_dropping_trigger = data.raw["item"]["rabbasca-psychosis"].spoil_to_trigger_result.trigger,
    spoil_quality_change = 1,
    lab_ignores_spoil_percent = true
  },
},
{
    type = "technology",
    name = "rabbasca-imaginary-science-pack",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/imaginary-science-pack.png",
    icon_size = 256,
    prerequisites = { "rabbasca-insanity-2" },
    effects = {
        { type = "unlock-recipe", recipe = "rabbasca-imaginary-science-pack-duplication" },
        { type = "laboratory-productivity", modifier = 0.1 }
    },
    research_trigger =
    {
      type = "craft-item",
      item = "rabbasca-imaginary-science-pack",
    }
},
{
    type = "technology",
    name = "rabbasca-inhibit-imagination",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/imaginary-science-pack-precursor.png",
    icon_size = 256,
    prerequisites = { "rabbasca-contained-imagination-refresh" },
    effects = {
        { type = "laboratory-productivity", modifier = -0.05 }
    },
    max_level = "infinite",
    -- show_levels_info = false,
    ignore_tech_cost_multiplier = false,
    unit = {
      time = 10,
      count_formula = "100000000",
      ingredients = {
        {"rabbasca-imaginary-science-pack", 1},
      }
    },
},
{
    type = "technology",
    name = "rabbasca-insanity-1",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/insanity.png",
    icon_size = 160,
    prerequisites = { "rabbasca-archives" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-psychosis" },
      { type = "unlock-recipe", recipe = "rabbasca-contained-imagination" },
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
    count = 1
    }
  },
  {
    type = "technology",
    name = "rabbasca-insanity-2",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/insanity.png",
    icon_size = 160,
    prerequisites = { "rabbasca-insanity-1" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-hellvent" },
      { type = "unlock-recipe", recipe = "rabbasca-rampant-imagination" },
      { type = "unlock-recipe", recipe = "rabbasca-imaginary-science-pack" },
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge",
        change = 0.25
      },
    },
    research_trigger =
    {
      type = "craft-item",
      item = "rabbasca-contained-imagination",
      count = 1
    }
},
{
    name = "rabbasca-restored-knowledge-mastery",
    type = "technology",
    icons = Rabbasca.icons({
      { proto = data.raw["recipe"]["rabbasca-restored-knowledge-2"] },
    }, 256),
    prerequisites = { "rabbasca-tinfoil-hat", "rabbasca-knowledge-efficiency", "rabbasca-warpfield-science-pack" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-restored-knowledge-2" },
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge-2",
        change = 3.5
      },
    },
    unit = {
      time = 60,
      count = 2000,
      ingredients = {
        { "space-science-pack",              1 },
        { "military-science-pack",           1 },
        { "utility-science-pack",            1 },
        { "production-science-pack",         1 },
        { "cryogenic-science-pack",          1 },
        { "rabbasca-warpfield-science-pack", 1 },
        { "rabbasca-imaginary-science-pack", 1 },
      }
    },
  },
  {
    name = "rabbasca-contained-imagination-refresh",
    type = "technology",
    icons = Rabbasca.icons({
      { proto = data.raw["recipe"]["rabbasca-contained-imagination-refresh"] },
    }, 256),
    prerequisites = { "rabbasca-imaginary-science-pack" },
    effects = {
      { type = "unlock-recipe", recipe = "rabbasca-contained-imagination-refresh" },
      { type = "unlock-recipe", recipe = "rabbasca-hellvent-refreshing" },
    },
    unit = {
      time = 30,
      count = 1000,
      ingredients = {
        { "automation-science-pack",         1 },
        { "logistic-science-pack",           1 },
        { "chemical-science-pack",           1 },
        { "space-science-pack",              1 },
        { "cryogenic-science-pack",          1 },
        { "athletic-science-pack",           1 },
        { "rabbasca-imaginary-science-pack", 1 },
      }
    },
  },
}