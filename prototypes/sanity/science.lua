data:extend {
{
  type = "item",
  name = "rabbasca-imaginary-science-pack-precursor",
  icon = "__rabbasca-assets__/graphics/recolor/icons/imaginary-science-pack-precursor.png",
  icon_size = 64,
  auto_recycle = false,
  weight = 0 * kg,
  stack_size = 200,
  subgroup = "science-pack",
  order = "k-r[rabbasca]-2",
  fuel_category = "rabbasca-imagination",
  fuel_value = "2MJ",
  burnt_result = "rabbasca-imaginary-science-pack",
  spoil_ticks = 10 * minute,
  spoil_result = "rabbasca-psychosis",
  lab_ignores_spoil_percent = true
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
    spoil_ticks = 3 * minute,
    spoil_result = "rabbasca-psychosis",
    spoil_quality_change = 1,
  },
},
{
    type = "technology",
    name = "rabbasca-imaginary-science-pack",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/imaginary-science-pack.png",
    icon_size = 256,
    prerequisites = { "rabbasca-insanity-2" },
    effects = {
        { type = "laboratory-productivity", modifier = 0.25 }
    },
    research_trigger =
    {
      type = "build-entity",
      entity = "rabbasca-imagination-altar",
    }
},
{
    type = "technology",
    name = "rabbasca-imaginary-catalyst",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/imaginary-science-pack-precursor.png",
    icon_size = 256,
    prerequisites = { "rabbasca-imaginary-science-pack" },
    effects = {
        { type = "laboratory-productivity", modifier = 0.25 }
    },
    max_level = "infinite",
    show_levels_info = false,
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 1 * hour,
      count_formula = "L",
      ingredients = {
        {"rabbasca-imaginary-science-pack-precursor", 1},
      }
    },
},
}