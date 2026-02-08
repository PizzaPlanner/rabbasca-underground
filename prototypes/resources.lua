data:extend {
  {
    type = "resource-category",
    name = "rabbasca-warp-anomaly"
  }
}

local anomaly_anim = {
  type = "animation",
  name = "rabbasca-warp-anomaly-animation",
  filename = "__rabbasca-assets__/graphics/entities/anomaly.png",
  line_length = 9,
  width = 434,
  height = 330,
  frame_count = 33,
  scale = 0.25,
  -- draw_as_glow = true, 
  -- blend_mode = "additive"
}

local st_anomaly = util.merge {
  table.deepcopy(data.raw["resource"]["calcite"]),
  {
    name = "rabbasca-warp-anomaly",
    icons = Rabbasca.icons({proto = data.raw["tool"]["rabbasca-warp-matrix"]}),
    minimum = 10,
    normal = 20,
    infinite = false,
    map_color = { 0.17, 0.31, 0.92 },
    resource_patch_search_radius = 1,
    highlight = true,
    cliff_removal_probability = 0,
    tree_removal_probability = 0,
    collision_box = {{ -1.5, -1.5}, {1.5, 1.5}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    map_grid = false,
    randomize_visual_position = false
  }
}
st_anomaly.stateless_visualisation = {
  {
    count = 1,
    render_layer = "object",
    animation = {
      priority = "extra-high",
      filename = "__rabbasca-assets__/graphics/entities/anomaly.png",
      line_length = 9,
      width = 434,
      height = 330,
      frame_count = 33,
      scale = 0.25,
      shift = util.by_pixel(0, -14)
    }
  },
}
st_anomaly.stage_counts = { 0 }
st_anomaly.stages = {
  layers =
  {
    util.sprite_load("__space-age__/graphics/entity/fluorine-vent/fluorine-vent",
    {
      priority = "extra-high",
      frame_count = 4,
      scale = 0.75,
      tint = { 0, 0, 0 }
    })
  }
}
st_anomaly.factoriopedia_simulation = {
  init =
  [[
    game.simulation.camera_position = {0.5, 0.5}
    local assembler = game.surfaces[1].create_entity{name = "rabbasca-warp-anomaly", position = {0, 0}, amount = 10}
  ]]
}

st_anomaly.minable.mining_time = 5
st_anomaly.category = "rabbasca-warp-anomaly"
st_anomaly.minable.results = {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}
st_anomaly.collision_mask = { layers = { out_of_map = true, harene = true, object = true } }
st_anomaly.autoplace = {
  probability_expression = "rabbasca_underground_anomaly_chance",
  richness_expression = "rabbasca_underground_anomaly_richness",
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
lithium_amide.autoplace = nil

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
  richness_expression = "rabbasca_underground_resource_richness",
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

data:extend{ lithium_amide, tungsten_ore, haronite_ore, st_anomaly, anomaly_anim }