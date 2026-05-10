data:extend{
{
    type = "technology",
    name = "rabbasca-underground",
    icons = Rabbasca.icons({
      { icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png", icon_size = 640 },
    }),
    prerequisites = { "interplanetary-construction-2", "rabbasca-ears-technology-2", "circuit-network", "harene-synthesis" },
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
    icons = data.raw["item"]["rabbasca-warpfield-excitement-rod"].icons,
    prerequisites = { "rabbasca-underground" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-excitement-rod"
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-warp-trace",
        count = 200
    }
},
{
    type = "technology",
    name = "rabbasca-anomaly-studies",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-technology-analysis-3" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-amplify-anomaly"
      },
    },
    unit = {
      time = 300,
      count = 10,
      ingredients = {
        { "rabbasca-warp-anomaly", 100 },
        { "rabbasca-twisted-knowledge", 1 },
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
      },
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
    name = "rabbasca-warp-technology-analysis-3",
    icons = Rabbasca.icons({ proto = data.raw["technology"]["biolab"] }),
    prerequisites = { "rabbasca-warp-technology-analysis-2" },
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
        item = "rabbasca-relicary-key",
        count = 1
    }
},
{
    type = "technology",
    name = "rabbasca-warp-technology-analysis-2",
    icons = Rabbasca.icons({ proto = data.raw["tool"]["rabbasca-quantum-device"] }),
    prerequisites = { "rabbasca-warp-technology-analysis-1" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-engine"
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-stabilizer-warp-sequence",
        count = 3
    }
},
{
    type = "technology",
    name = "rabbasca-coordinate-system",
    icons = Rabbasca.icons({ proto = data.raw["tool"]["rabbasca-coordinate-system"] }),
    prerequisites = { "rabbasca-quantum-device", "rabbasca-spatial-anchor" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-coordinate-system"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 300,
      count = 5,
      ingredients = {
        { "rabbasca-warp-anomaly", 100 },
        { "rabbasca-twisted-knowledge", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-stability-pylon",
    icons = Rabbasca.icons({ proto = data.raw["item"]["rabbasca-stability-pylon"] }),
    prerequisites = { "rabbasca-spatial-anchor" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-stability-pylon"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 300,
      count = 2,
      ingredients = {
        { "rabbasca-warp-anomaly", 100 },
        { "rabbasca-twisted-knowledge", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-relicary-remote",
    icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
    prerequisites = { "rabbasca-quantum-device" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-relicary-remote"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 300,
      count = 2,
      ingredients = {
        { "rabbasca-warp-anomaly", 100 },
        { "rabbasca-twisted-knowledge", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-quantum-device",
    icons = Rabbasca.icons({ proto = data.raw["tool"]["rabbasca-quantum-device"] }),
    prerequisites = { "rabbasca-warp-technology-analysis-3" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-quantum-device"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 300,
      count = 5,
      ingredients = {
        { "rabbasca-warp-anomaly", 100 },
        { "rabbasca-twisted-knowledge", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-spatial-anchor",
    icons = Rabbasca.icons({ proto = data.raw["tool"]["rabbasca-spatial-anchor"] }),
    prerequisites = { "rabbasca-warp-technology-analysis-3" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-spatial-anchor"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 300,
      count = 10,
      ingredients = {
        { "rabbasca-warp-anomaly", 100 },
        { "rabbasca-twisted-knowledge", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-self-made-warp-pylon",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-technology-analysis-3" },
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
    unit = {
      time = 300,
      count = 20,
      ingredients = {
        { "rabbasca-warp-anomaly", 100 },
        { "rabbasca-twisted-knowledge", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-knowledge-efficiency",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-relicary-remote" },
    effects = {
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-twisted-knowledge",
        change = 0.25
      }
    },
    max_level = "infinite",
    unit = {
      time = 600,
      count_formula = "3 + 2 * L",
      ingredients = {
        { "rabbasca-warp-anomaly", 1 },
        { "rabbasca-twisted-knowledge", 1 },
      }
    }
},
}

local warp_tech_3 = data.raw["technology"]["interplanetary-construction-3"]
warp_tech_3.prerequisites = { "rabbasca-warp-technology-analysis-3" }
warp_tech_3.unit = {
  time = 300,
  count = 20,
  ingredients = {
    { "rabbasca-warp-anomaly", 100 },
    { "rabbasca-twisted-knowledge", 1 },
  }
}