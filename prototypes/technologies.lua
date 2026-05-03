data:extend{
{
    type = "technology",
    name = "rabbasca-underground",
    icons = Rabbasca.icons({
      { icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png", icon_size = 640 },
    }),
    prerequisites = { "interplanetary-construction-2", "rabbasca-ears-technology-2", "fusion-reactor", "harene-synthesis" },
    essential = true,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-locate-stabilizer"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-spacetime-sensor"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-collector-pylon"
      },
      {
        type = "unlock-space-location",
        space_location = "rabbasca-underground",
        use_icon_overlay_constant = true
      },
    },
    unit = {
      time = 60,
      count = 1000,
      ingredients = {
        {"metallurgic-science-pack", 1},
        {"electromagnetic-science-pack", 1},
        {"agricultural-science-pack", 1},
        {"athletic-science-pack", 1},
        {"cryogenic-science-pack", 1},
      }
    }
},

{
    type = "technology",
    name = "rabbasca-warp-technology-analysis-1",
    icons = Rabbasca.icons({proto = data.raw["technology"]["biolab"]}),
    prerequisites = { "rabbasca-underground" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-tech-analyzer"
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-warp-cell",
        count = 5
    }
},
{
    type = "technology",
    name = "rabbasca-anomaly-studies",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-technology-analysis-1" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-amplify-anomaly"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 1000,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
      }
    }
},


{
    type = "technology",
    name = "rabbasca-total-recall",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
    prerequisites = { "rabbasca-warp-technology-analysis-2" },
    effects = {
      {
        type = "nothing",
        effect_description = { "recipe-description.rabbasca-total-recall" }
      }
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 2000,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-lithium-amide-fission",
    icons = Rabbasca.icons({{proto = data.raw["recipe"]["rabbasca-lithium-amide-fission"]}, { shift_multiplier = 4 }}),
    prerequisites = { "rabbasca-underground" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-lithium-amide-fission"
      }
    },
    research_trigger = {
      type = "mine-entity",
      entity = "rabbasca-lithium-amide"
    }
},
{
    type = "technology",
    name = "rabbasca-beta-carotene-from-yumako",
    icons = Rabbasca.icons({{proto = data.raw["recipe"]["rabbasca-beta-carotene-from-yumako"]}, { shift_multiplier = 4 }}),
    prerequisites = { "rabbasca-underground" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-beta-carotene-from-yumako"
      }
    },
    research_trigger = {
      type = "mine-entity",
      entity = "rabbasca-yumako-mashup"
    }
},
{
    type = "technology",
    name = "rabbasca-supercharged-module",
    icons = Rabbasca.icons({proto = data.raw["technology"]["modules"]}),
    prerequisites = { "rabbasca-warp-technology-analysis-3" },
    effects = {

    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 100,
      ingredients = {
        { "rabbasca-warp-trace", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-warp-technology-analysis-2",
    icons = Rabbasca.icons({ proto = data.raw["tool"]["rabbasca-spatial-anchor"] }),
    prerequisites = { "rabbasca-warp-technology-analysis-1" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-spatial-anchor"
      }
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 5,
      count = 100,
      ingredients = {
        { "rabbasca-warp-matrix", 10 },
        { "rabbasca-warp-trace",  1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-warp-technology-analysis-3",
    icons = Rabbasca.icons({ proto = data.raw["tool"]["rabbasca-quantum-device"] }),
    prerequisites = { "rabbasca-warp-technology-analysis-2" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-quantum-device"
      }
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 500,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
        { "rabbasca-spacetime-sensor", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-warp-technology-analysis-4",
    icons = Rabbasca.icons({ proto = data.raw["tool"]["rabbasca-coordinate-system"] }),
    prerequisites = { "rabbasca-warp-technology-analysis-3" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-coordinate-system"
      }
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 1000,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
        { "rabbasca-spacetime-sensor", 1 },
        { "rabbasca-quantum-device", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-permanent-floor-expansion-1",
    icons = Rabbasca.icons({ proto = data.raw["technology"]["concrete"] }),
    prerequisites = { "rabbasca-warp-technology-analysis-2" },
    localized_description = { "rabbasca-permanent-floor-expansion" },
    effects = {
      {
        type = "nothing",
        effect_description = { "rabbasca-extra.rabbasca-floor-expansion" }
      }
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 1000,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
        { "rabbasca-spacetime-sensor", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-permanent-floor-expansion-2",
    icons = Rabbasca.icons({ proto = data.raw["technology"]["concrete"] }),
    prerequisites = { "rabbasca-permanent-floor-expansion-1", "rabbasca-warp-technology-analysis-4" },
    localized_description = { "rabbasca-permanent-floor-expansion" },
    effects = {
      {
        type = "nothing",
        effect_description = { "rabbasca-extra.rabbasca-floor-expansion" }
      }
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 2000,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
        { "rabbasca-coordinate-system", 1 },
        { "rabbasca-spacetime-sensor", 1 },
        { "rabbasca-quantum-device", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-self-made-warp-pylon",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-technology-analysis-4" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-core"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-pylon"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 1000,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
        { "rabbasca-coordinate-system", 1 },
        { "rabbasca-spacetime-sensor", 1 },
        { "rabbasca-quantum-device", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-warp-uplink-2",
    icons = data.raw["item"]["rabbasca-warp-uplink-2"].icons,
    prerequisites = { "rabbasca-warp-technology-analysis-4" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-uplink-2"
      }
    },
    unit = {
      time = 10,
      count = 1000,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
        { "rabbasca-coordinate-system", 1 },
        { "rabbasca-spacetime-sensor", 1 },
        { "rabbasca-quantum-device", 1 },
      }
    }
},
}

local warp_tech_3 = data.raw["technology"]["interplanetary-construction-3"]
warp_tech_3.prerequisites = { "rabbasca-warp-technology-analysis-3" }
warp_tech_3.unit = {
  time = 10,
  count = 1000,
  ingredients = {
    { "rabbasca-warp-matrix", 1 },
    { "rabbasca-spatial-anchor", 1 },
    { "rabbasca-spacetime-sensor", 1 },
    { "rabbasca-quantum-device", 1 },
  }
}