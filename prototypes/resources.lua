local carbonic_ore = util.merge {
  table.deepcopy(data.raw["resource"]["coal"]),
  {
    name = "rabbasca-carbonic-ore",
    icon = data.raw["item"]["coal"].icon,
    minimum = 100,
    normal = 100,
    infinite = true,
    map_color = { 0.03, 0.1, 0.07 },
    -- stages = { sheet = { filename = "__rabbasca-assets__/graphics/recolor/icons/carotenoid-ore.png" } },
    cliff_removal_probability = 0,
    tree_removal_probability = 0,
  }
}
carbonic_ore.minable.results =
{
  { type = "item", name = "coal",    amount = 1, probability = 0.25, },
  { type = "item", name = "stone",    amount = 1, probability = 0.1, },
  { type = "item", name = "sulfur",   amount = 1, probability = 0.03, },
  -- { type = "item", name = "haronite",  amount = 1, probability = 0.03, },
}
carbonic_ore.autoplace = {
  tile_restriction = { "rabbasca-underground-rubble" },
  probability_expression = "rabbasca_underground_resources",
  richness_expression = "100",
}

local lithium_amide = util.merge {
  table.deepcopy(data.raw["resource"]["calcite"]),
  {
    name = "rabbasca-lithium-amide",
    icon = data.raw["item"]["calcite"].icon,
    minimum = 100,
    normal = 100,
    infinite = false,
    map_color = { 0.85, 0.94, 0.92 },
    -- stages = { sheet = { filename = "__rabbasca-assets__/graphics/recolor/icons/carotenoid-ore.png" } },
    cliff_removal_probability = 0,
    tree_removal_probability = 0,
  }
}
lithium_amide.minable.mining_time = 0.5
lithium_amide.minable.results = {{ type = "item", name = "rabbasca-lithium-amide", amount = 1 }}
lithium_amide.autoplace = {
  probability_expression = "rabbasca_underground_resource_spots",
  richness_expression = "500 * (1 + rabbasca_underground_resource_spots)",
}

local tungsten_ore = util.merge {
  data.raw["resource"]["tungsten-ore"],
  {
    name = "rabbasca-underground-tungsten-ore",
    factoriopedia_alternative = "tungsten-ore",
    localised_name = { "entity-name.tungsten-ore" },
    localised_description = { "entity-description.tungsten-ore" }
  }
}

tungsten_ore.autoplace = {
  probability_expression = "rabbasca_underground_resource_spots",
  richness_expression = "500 * (1 + rabbasca_underground_resource_spots)",
}

local haronite_ore = util.merge {
  tungsten_ore,
  data.raw["item"]["haronite"],
  {
    name = "haronite",
    type = "resource",
    category = "basic-solid",
    factoriopedia_alternative = "haronite",
    localised_name = { "item-name.haronite" },
    localised_description = { "item-description.haronite" }
  }
}
haronite_ore.minable.mining_time = 3
haronite_ore.minable.results = {{ type = "item", name = "haronite", amount = 1, percent_spoiled = 0.9 }}

data:extend{ lithium_amide, tungsten_ore, haronite_ore }