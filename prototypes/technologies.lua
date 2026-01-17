data:extend{
{
    type = "technology",
    name = "rabbasca-underground-preparations",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    prerequisites = { "interplanetary-construction-2", "rabbasca-ears-technology-2", "fusion-reactor", "harene-synthesis" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-locate-stabilizer"
      },
      {
        type = "unlock-space-location",
        space_location = "rabbasca-underground",
        use_icon_overlay_constant = true
      },
    },
    unit = {
      time = 60,
      count = 100,
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
    name = "rabbasca-underground",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    prerequisites = { "rabbasca-underground-preparations" },
    effects = { },
    research_trigger =
    {
      type = "scripted",
      trigger_description = { "rabbasca-extra.trigger-locate-underground" }
    }
},
{
    type = "technology",
    name = "rabbasca-warp-stabilizer",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix-2.png",
    icon_size = 204,
    prerequisites = { "rabbasca-underground" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-matrix"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-tech-analyzer"
      },
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
    name = "rabbasca-warp-technology-analysis",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-stabilizer" },
    effects = {

    },
    ignore_tech_cost_multiplier = true,
    order = "r[warp-tech]-0[analysis]",
    unit = {
      time = 10,
      count = 100,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
        { "rabbasca-coordinate-calibrations", 1 },
        { "rabbasca-spacetime-evolutionizer", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-self-made-warp-pylon",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-technology-analysis" },
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
        { "rabbasca-coordinate-calibrations", 1 },
        { "rabbasca-spacetime-evolutionizer", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-unrestricted-warp-pad",
    icon = data.raw["technology"]["space-platform"].icon,
    icon_size = data.raw["technology"]["space-platform"].icon_size,
    prerequisites = { "rabbasca-warp-technology-analysis" },
    effects = {
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 10,
      count = 1000,
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
        { "rabbasca-spatial-anchor", 1 },
        { "rabbasca-coordinate-calibrations", 1 },
        { "rabbasca-spacetime-evolutionizer", 1 },
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
    { "rabbasca-coordinate-calibrations", 1 },
    { "rabbasca-spacetime-evolutionizer", 1 },
  }
}