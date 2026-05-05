data:extend({
{
    type = "technology",
    name = "rabbasca-warp-stabilizer",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
    rabbasca_underground_temporary = true,
    prerequisites = { "rabbasca-underground" },
    effects = { 
      {
        type ="unlock-recipe",
        recipe = "rabbasca-stabilize-warpfield"
      },
      {
        type ="unlock-recipe",
        recipe = "rabbasca-warp-cell"
      },
      {
        type ="unlock-recipe",
        recipe = "rabbasca-abandon-stabilizer"
      },
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = { "rabbasca-extra.trigger-locate-underground" }
    }
},
{
    type = "technology",
    name = "rabbasca-anomaly-expansion",
    icons = Rabbasca.icons({{ proto = data.raw["tool"]["rabbasca-warp-matrix"] }}),
    prerequisites = { "rabbasca-warp-stabilizer", "rabbasca-anomaly-studies" },
    rabbasca_underground_temporary = true,
    effects = {
      {
        type = "nothing",
        effect_description = { "rabbasca-extra.rabbasca-anomaly-expansion" }
      }
    },
    ignore_tech_cost_multiplier = true,
    max_level = "infinite",
    unit = {
      time = 10,
      count_formula = "25 + L^2 * 10",
      ingredients = {
        { "rabbasca-warp-matrix", 1 },
      }
    }
},
{
    type = "technology",
    name = "rabbasca-warp-floor-expansion",
    icons = Rabbasca.icons({ proto = data.raw["technology"]["concrete"] }),
    prerequisites = { "rabbasca-warp-stabilizer" },
    rabbasca_underground_temporary = true,
    effects = {
      {
        type = "nothing",
        effect_description = { "rabbasca-extra.rabbasca-floor-expansion" }
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
    name = "rabbasca-stabilizer-warpdrive",
    icons = Rabbasca.icons({
      { proto = data.raw["planet"]["rabbasca"], scale = 0.5, shift = {-8, -8} }, 
      { proto = data.raw["planet"]["aquilo"],   scale = 0.5, shift = {8, -8} },
      { proto = data.raw["planet"]["vulcanus"], scale = 0.5, shift = {8, 8} },
      { proto = data.raw["planet"]["fulgora"],  scale = 0.5, shift = {-8, 8} } }),
    prerequisites = { "rabbasca-warp-stabilizer" },
    rabbasca_underground_temporary = true,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-stabilizer-warp-sequence",
      }
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "scripted",
        trigger_description = { "rabbasca-extra.trigger-repair-warpdrive" }
    }
},
{
    type = "technology",
    name = "rabbasca-stabilizer-extractor",
    icons = Rabbasca.icons({ proto = data.raw["technology"]["big-mining-drill"] }),
    prerequisites = { "rabbasca-stabilizer-warpdrive" },
    rabbasca_underground_temporary = true,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-stabilizer-toggle-extractor"
      }
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "scripted",
        trigger_description = { "rabbasca-extra.trigger-repair-extractor" }
    }
},
{
    type = "technology",
    name = "rabbasca-stabilizer-relichunter",
    icons = Rabbasca.icons({ proto = data.raw["technology"]["big-mining-drill"] }),
    prerequisites = { "rabbasca-stabilizer-warpdrive" },
    rabbasca_underground_temporary = true,
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-stabilizer-toggle-relichunter"
      }
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "scripted",
        trigger_description = { "rabbasca-extra.trigger-repair-relichunter" }
    }
},
})