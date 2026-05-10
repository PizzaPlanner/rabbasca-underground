local bonus_cell_icons = Rabbasca.icons({
  { proto = data.raw["item-with-tags"]["rabbasca-warp-cell-recharging"], icon_size = 64 },
  { proto = data.raw["virtual-signal"]["signal-1"], icon_size = 64, scale = 0.3, shift = { 8, 8 } },
})
local function bonus_icon(proto)
  return Rabbasca.icons({
  { proto = proto, icon_size = 64 },
  { proto = data.raw["virtual-signal"]["signal-1"], icon_size = 64, scale = 0.3, shift = { 8, 8 } },
})
end

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
        recipe = "rabbasca-abandon-stabilizer"
      },
    },
    research_trigger =
    {
      type = "scripted",
      trigger_description = { "rabbasca-extra.trigger-locate-underground" }
    }
},
-- {
--     type = "technology",
--     name = "rabbasca-anomaly-expansion",
--     icons = Rabbasca.icons({{ proto = data.raw["tool"]["rabbasca-warp-anomaly"] }}),
--     prerequisites = { "rabbasca-warp-stabilizer", "rabbasca-anomaly-studies" },
--     rabbasca_underground_temporary = true,
--     effects = {
--       {
--         type = "nothing",
--         effect_description = { "rabbasca-extra.rabbasca-anomaly-expansion" }
--       }
--     },
--     ignore_tech_cost_multiplier = true,
--     max_level = "infinite",
--     unit = {
--       time = 10,
--       count_formula = "25 + L^2 * 10",
--       ingredients = {
--         { "rabbasca-warp-anomaly", 1 },
--       }
--     }
-- },
{
    type = "technology",
    name = "rabbasca-warp-floor-expansion-5",
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
    level = 5,
    max_level = 36,
    unit = {
      time = 10,
      count_formula = "(10 + L ^ 4) * L^2",
      ingredients = {
        { "rabbasca-warp-anomaly", 1 },
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
      },
      {
        type = "nothing",
        icons = bonus_cell_icons,
        effect_description = { "rabbasca-extra.unlock-bonus-warpcell" }
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
    prerequisites = { "rabbasca-warp-stabilizer" },
    rabbasca_underground_temporary = true,
    effects = {
      {
        type = "nothing",
        icons = bonus_icon(data.raw["mining-drill"]["rabbasca-collector-pylon"]),
        effect_description = { "rabbasca-extra.unlock-bonus-warpcell" }
      }
    },
    level = 2,
    max_level = 24,
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "scripted",
        trigger_description = { "rabbasca-extra.trigger-repair-extractor" }
    }
},
})