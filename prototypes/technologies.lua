data:extend{
{
    type = "technology",
    name = "rabbasca-underground",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    prerequisites = { "interplanetary-construction-2", "rabbasca-ears-technology-2", "fusion-reactor", "harene-synthesis" },
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
    name = "rabbasca-warp-stabilizer",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
    rabbasca_underground_temporary = true,
    prerequisites = { "rabbasca-underground" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-stabilize-warpfield"
      },
      {
        type = "nothing",
        effect_description = { "recipe-description.rabbasca-stabilizer-consumer" }
      }
    },
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-reboot-stabilizer",
        count = 1
    }
},
{
    type = "technology",
    name = "rabbasca-warp-technology-analysis-1",
    icons = Rabbasca.icons({proto = data.raw["tool"]["rabbasca-spatial-anchor"]}),
    prerequisites = { "rabbasca-underground" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-spatial-anchor"
      },
    },
    ignore_tech_cost_multiplier = true,
    order = "r[warp-tech]-0[analysis]",
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-stabilize-warpfield",
        count = 150
    }
},
{
    type = "technology",
    name = "rabbasca-warp-technology-analysis-2",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-technology-analysis-1" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-tech-analyzer"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-collector-pylon"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-amplify-anomaly"
      },
    },
    ignore_tech_cost_multiplier = true,
    order = "r[warp-tech]-0[analysis]",
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-spatial-anchor",
        count = 10
    }
},
{
    type = "technology",
    name = "rabbasca-warp-floor-expansion",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
    prerequisites = { "rabbasca-warp-stabilizer" },
    rabbasca_underground_temporary = true,
    effects = {
      {
        type = "give-item",
        item = "rabbasca-reboot-stabilizer",
        count = 1,
      }
    },
    ignore_tech_cost_multiplier = true,
    max_level = 8,
    unit = {
      time = 10,
      count_formula = "(10 + L ^ 4) * L^2",
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
      }
    }
},
{
    type = "technology",
    name = "rabbasca-lithium-amide-fission",
    icons = Rabbasca.icons({{proto = data.raw["recipe"]["rabbasca-lithium-amide-fission"]}}),
    prerequisites = { "rabbasca-warp-technology-analysis-1" },
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
    name = "rabbasca-self-made-warp-pylon",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-technology-analysis-2" },
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
    name = "rabbasca-ears-powered-space-platform",
    icon = data.raw["technology"]["space-platform"].icon,
    icon_size = data.raw["technology"]["space-platform"].icon_size,
    prerequisites = { "rabbasca-warp-technology-analysis-2" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-space-platform-starter-pack"
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
warp_tech_3.prerequisites = { "rabbasca-self-made-warp-pylon" }
warp_tech_3.unit = {
  time = 10,
  count = 3000,
  ingredients = {
    { "rabbasca-warp-matrix", 1 },
    { "rabbasca-spatial-anchor", 1 },
    { "rabbasca-coordinate-system", 1 },
    { "rabbasca-spacetime-sensor", 1 },
    { "rabbasca-quantum-device", 1 },
  }
}