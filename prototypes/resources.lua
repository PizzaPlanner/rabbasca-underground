data:extend {
  {
    type = "resource-category",
    name = "rabbasca-warp-anomaly"
  }
}

local st_anomaly = util.merge {
  table.deepcopy(data.raw["resource"]["calcite"]),
  {
    name = "rabbasca-warp-anomaly",
    icons = Rabbasca.icons({proto = data.raw["item"]["rabbasca-warp-anomaly"]}),
    minimum = 10,
    normal = 20,
    infinite = false,
    map_color = { 0.17, 0.31, 0.92 },
    resource_patch_search_radius = 1,
    highlight = true,
    cliff_removal_probability = 0,
    tree_removal_probability = 0,
    collision_box = {{ -1.3, -1.3}, {1.3, 1.3}},
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
      -- priority = "extra-high",
      filename = "__rabbasca-assets__/graphics/entities/anomaly.png",
      line_length = 5,
      width = 412,
      height = 318,
      frame_count = 33,
      scale = 0.25,
      shift = util.by_pixel(0, -13)
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

st_anomaly.minable.mining_time = 1
st_anomaly.category = "rabbasca-warp-anomaly"
st_anomaly.minable.results = {{ type = "item", name = "rabbasca-warp-anomaly", amount = 1 }}
st_anomaly.collision_mask = { layers = { out_of_map = true, harene = true, object = true } }
st_anomaly.autoplace = {
  probability_expression = "rabbasca_underground_anomaly_chance",
  richness_expression = "rabbasca_underground_anomaly_richness",
}

local lithium_amide = util.merge {
  table.deepcopy(data.raw["resource"]["calcite"]),
  {
    name = "rabbasca-lithium-amide",
    icon = data.raw["item"]["rabbasca-lithium-amide"].icon,
    icon_size = 128,
    minimum = 100,
    normal = 100,
    infinite = false,
    stages = { sheet = { filename = "__rabbasca-assets__/graphics/recolor/textures/lithium-amide-ore.png" } },
    cliff_removal_probability = 0,
    tree_removal_probability = 0,
  }
}
lithium_amide.map_color = { 0.74, 0.94, 0.92 }
lithium_amide.minable.mining_time = 0.5
lithium_amide.minable.results = {{ type = "item", name = "rabbasca-lithium-amide", amount = 1 }}
lithium_amide.autoplace = nil

local mashup = util.merge {
  table.deepcopy(data.raw["resource"]["calcite"]),
  {
    name = "rabbasca-yumako-mashup",
    icons = Rabbasca.icons({ proto = data.raw["capsule"]["yumako-mash"] }),
    minimum = 100,
    normal = 100,
    infinite = false,
    stages = { sheet = { filename = "__rabbasca-assets__/graphics/recolor/icons/carotenoid-ore.png" } },
    cliff_removal_probability = 0,
    tree_removal_probability = 0,
  }
}
mashup.map_color = { 0.74, 0.38, 0.1 }
mashup.minable.mining_time = 0.5
mashup.minable.results = {
  { type = "item", name = "spoilage", amount = 1, independent_probability = 0.4 },
  { type = "item", name = "coal", amount = 1, independent_probability = 0.27 },
  { type = "item", name = "yumako-mash", amount = 1, percent_spoiled = 0.7, independent_probability = 0.15 },
  { type = "item", name = "yumako-mash", amount = 1, percent_spoiled = 0.4, independent_probability = 0.08 },
}
lithium_amide.autoplace = nil

local haronite_ore = util.merge {
  data.raw["resource"]["tungsten-ore"],
  data.raw["item"]["haronite"],
  {
    name = "haronite",
    type = "resource",
    categories = { "basic-solid" },
    factoriopedia_alternative = "haronite",
    localised_name = { "item-name.haronite" },
    -- stages = { sheet = { filename = "__rabbasca-assets__/graphics/recolor/textures/haronite-ore.png" } },
    localised_description = { "item-description.haronite" }
  }
}
haronite_ore.minable.mining_time = 3
haronite_ore.minable.results = {{ type = "item", name = "haronite", amount = 1, percent_spoiled = 0.8 }}
haronite_ore.autoplace = nil

local holmium_ore = util.merge {
  data.raw["resource"]["tungsten-ore"],
  data.raw["item"]["holmium-ore"],
  {
    name = "rabbasca-holmium-ore",
    type = "resource",
    categories = { "basic-solid" },
    -- factoriopedia_alternative = "holmium-ore",
    localised_name = { "item-name.holmium-ore" },
    stages = { sheet = { filename = "__rabbasca-assets__/graphics/recolor/textures/holmium-ore.png" } },
    localised_description = { "item-description.holmium-ore" }
  }
}
holmium_ore.minable.mining_time = 1.5
holmium_ore.minable.results = {{ type = "item", name = "holmium-ore", amount = 1 }}
holmium_ore.autoplace = nil

data:extend{ lithium_amide, haronite_ore, st_anomaly, holmium_ore, mashup }