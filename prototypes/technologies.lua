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
      {
        type = "unlock-recipe",
        hidden = true,
        recipe = "rabbasca-emergency-fuel"
      },
      {
        type = "unlock-recipe",
        hidden = true,
        recipe = "rabbasca-warp-trace"
      },
      {
        type = "unlock-recipe",
        hidden = true,
        recipe = "rabbasca-stabilizer-recharge"
      },
      {
        type = "unlock-recipe",
        hidden = true,
        recipe = "rabbasca-abandon-stabilizer"
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
    name = "rabbasca-anomaly-studies-1",
    prerequisites = { "rabbasca-underground" },
    icons = Rabbasca.icons({
      {proto = data.raw["item"]["rabbasca-warpfield-excitement-rod"], shift = {-8, -8} },
      {proto = data.raw["item"]["rabbasca-warpfield-engine"], shift = {8, 8} },
    }),
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-excitement-rod"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-engine",
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "mine-entity",
        entities = { "rabbasca-warp-anomaly" },
    }
},
{
    type = "technology",
    name = "rabbasca-anomaly-studies-2",
    icon = "__rabbasca-assets__/graphics/icons/warp-anomaly.png",
    icon_size = 256,
    prerequisites = { "rabbasca-relicary-remote" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-amplify-anomaly"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-hunt-anomalies"
      },
    },
    localised_description = { "technology-description.rabbasca-anomaly-studies-floor" },
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-obscure-theories",
        count = 250
    }
},
{
    type = "technology",
    name = "rabbasca-lithium-amide-fission",
    icons = Rabbasca.icons({{proto = data.raw["recipe"]["rabbasca-lithium-amide-fission"]}}, 256),
    prerequisites = { "rabbasca-underground" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-lithium-amide-fission"
      },
    },
    research_trigger = {
      type = "mine-entity",
      entities = { "rabbasca-lithium-amide" }
    }
},
{
    type = "technology",
    name = "rabbasca-plastic-from-petroleum-gas",
    icons = Rabbasca.icons({ {proto = data.raw["recipe"]["rabbasca-plastic-from-petroleum-gas"]} }, 256),
    prerequisites = { "rabbasca-lithium-amide-fission" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-plastic-from-petroleum-gas"
      },
    },
    research_trigger = {
      type = "scripted",
      trigger_description = { "rabbasca-extra.unlock-tech-on-warp", "rabbasca" }
    }
},
{
    type = "technology",
    name = "rabbasca-beta-carotene-from-yumako",
    icons = Rabbasca.icons({{proto = data.raw["recipe"]["rabbasca-beta-carotene-from-yumako"]}}, 256),
    prerequisites = { "rabbasca-lithium-amide-fission" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-beta-carotene-from-yumako"
      }
    },
    research_trigger = {
      type = "mine-entity",
      entities = { "rabbasca-yumako-mashup" }
    }
},
{
    type = "technology",
    name = "rabbasca-warpfield-science-pack",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/warp-science-pack-big.png",
    icon_size = 256,
    prerequisites = { "rabbasca-warp-core", "rabbasca-anomaly-studies-2" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-science-pack"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-science-pack-wi-download"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-science-pack-wi-upload"
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-restored-knowledge",
        count = 100
    }
},
{
    type = "technology",
    name = "rabbasca-archives",
    icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-anomaly-studies-1" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-relichunter"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-hunt-relicaries"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-obscure-theories"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-restored-knowledge"
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-warpfield-engine",
        count = 5
    }
},
{
    type = "technology",
    name = "rabbasca-relicary-remote",
    icons = Rabbasca.icons({{ proto = data.raw["item"]["rabbasca-relicary-remote"] }}),
    prerequisites = { "rabbasca-archives" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-relicary-remote"
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-obscure-theories",
        count = 100
    }
},
{
    type = "technology",
    name = "rabbasca-nearby-access",
    icons = Rabbasca.icons({ proto = data.raw["container"]["rabbasca-remote-access-chest"] }),
    prerequisites = { "rabbasca-warpfield-science-pack" },
    hidden = true, -- WIP
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-remote-access-chest"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 60,
      count = 800,
      ingredients = {
        {"rabbasca-warpfield-science-pack", 1},
      }
    },
},
{
    type = "technology",
    name = "rabbasca-quantum-device",
    icons = Rabbasca.icons({ proto = data.raw["item"]["rabbasca-quantum-device"] }),
    prerequisites = { "rabbasca-archives" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-quantum-device"
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-restored-knowledge",
        count = 25
    }
},
{
    type = "technology",
    name = "rabbasca-warp-core",
    icon = "__rabbasca-assets__/graphics/recolor/icons/warp-core.png",
    icon_size = 64,
    prerequisites = { "rabbasca-quantum-device" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-core"
      },
    },
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-quantum-device",
        count = 10
    }
},
{
    type = "technology",
    name = "rabbasca-self-made-warp-pylon",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warpfield-science-pack" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-pylon"
      },
    },
    unit = {
      time = 60,
      count = 600,
      ingredients = {
        {"rabbasca-warpfield-science-pack", 1},
      }
    },
},
{
    type = "technology",
    name = "rabbasca-ufo",
    icon = "__rabbasca-assets__/graphics/recolor/icons/warpotron.png",
    icon_size = 64,
    prerequisites = { "rabbasca-warpfield-science-pack", "tesla-weapons", "spidertron", "rabbasca-insanity-2" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-ufo"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-summon-ufo"
      },
    },
    unit = {
      time = 60,
      count = 1000,
      ingredients = {
        {"military-science-pack", 1},
        {"athletic-science-pack", 1},
        {"rabbasca-warpfield-science-pack", 1},
      }
    },
},
{
    type = "technology",
    name = "rabbasca-knowledge-efficiency",
    icons = Rabbasca.icons({{ proto = data.raw["item"]["rabbasca-restored-knowledge"] }}),
    prerequisites = { "rabbasca-warpfield-science-pack", "rabbasca-insanity-1" },
    effects = {
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-restored-knowledge",
        change = 0.25
      },
    },
    max_level = "infinite",
    unit = {
      time = 60,
      count_formula = "25 * L * L",
      ingredients = {
        {"athletic-science-pack", 1},
        {"rabbasca-warpfield-science-pack", 1},
      }
    }
},
{
    type = "technology",
    name = "rabbasca-harene-efficiency",
    icons = Rabbasca.icons({{ proto = data.raw["technology"]["harene-synthesis"]}}),
    prerequisites = { "rabbasca-warpfield-science-pack" },
    effects = {
      {
        type = "change-recipe-productivity",
        recipe = "harene",
        change = 0.08
      },
    },
    max_level = "infinite",
    unit = {
      time = 60,
      count_formula = "75 + 82 * L * (L + 7)",
      ingredients = {
        {"athletic-science-pack", 1},
        {"rabbasca-warpfield-science-pack", 1},
      }
    }
},
{
    type = "technology",
    name = "rabbasca-supercharged-module",
    icons = Rabbasca.icons({proto = data.raw["technology"]["modules"]}),
    prerequisites = { "rabbasca-warpfield-science-pack", "interplanetary-construction-3", "speed-module-3", "rabbasca-insanity-2" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-supercharged-module"
      },
    },
    unit = {
      time = 60,
      count = 1000,
      ingredients = {
        {"athletic-science-pack", 1},
        {"rabbasca-warpfield-science-pack", 1},
      }
    },
},
{
    type = "technology",
    name = "rabbasca-warp-stabilizer-powerspike-1-unlock",
    icons = Rabbasca.icons({
      {proto = data.raw["item"]["rabbasca-stabilizer-warp-sequence"]},
      {proto = data.raw["item"]["rabbasca-progress-powerspike"]},
    }, 256),
    prerequisites = { "rabbasca-anomaly-studies-1" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-stabilizer-warp-sequence"
      },
    },
    localised_name = { "item-name.rabbasca-stabilizer-warp-sequence" },
    research_trigger =
    {
      type = "scripted",
      trigger_description = { "rabbasca-extra.trigger-unlock-powerspike", tostring(1) }
    }
},
{
    type = "technology",
    name = "rabbasca-warp-stabilizer-powerspike-4-unlock",
    icons = Rabbasca.icons({
      {proto = data.raw["item"]["rabbasca-collector-pylon"]},
      {proto = data.raw["item"]["rabbasca-progress-powerspike"]},
    }, 256),
    prerequisites = { "rabbasca-warp-stabilizer-powerspike-1-unlock" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-collector-pylon"
      },
    },
    localised_name = { "entity-name.rabbasca-collector-pylon" },
    research_trigger =
    {
      type = "scripted",
      trigger_description = { "rabbasca-extra.trigger-unlock-powerspike", tostring(4) }
    }
  },
  {
    type = "technology",
    name = "rabbasca-warp-stabilizer-powerspike-5-unlock",
    icons = Rabbasca.icons({
      {proto = data.raw["item"]["rabbasca-stability-pylon"]},
      {proto = data.raw["item"]["rabbasca-progress-powerspike"]},
    }, 256),
    prerequisites = { "rabbasca-warp-stabilizer-powerspike-4-unlock" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-stability-pylon"
      },
    },
    localised_name = { "entity-name.rabbasca-stability-pylon" },
    research_trigger =
    {
      type = "scripted",
      trigger_description = { "rabbasca-extra.trigger-unlock-powerspike", tostring(5) }
    }
  },
  {
    type = "technology",
    name = "rabbasca-warp-stabilizer-powerspike-6-unlock",
    icons = Rabbasca.icons({
      {proto = data.raw["item-with-inventory"]["rabbasca-warp-cell-recharging"]},
      {proto = data.raw["item"]["rabbasca-progress-powerspike"]},
    }, 256),
    prerequisites = { "rabbasca-warp-stabilizer-powerspike-5-unlock" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-cell-recharging"
      },
    },
    localised_name = { "item-name.rabbasca-warp-cell-recharging" },
    research_trigger =
    {
      type = "scripted",
      trigger_description = { "rabbasca-extra.trigger-unlock-powerspike", tostring(6) }
    }
  },
}

if settings.startup["rabbasca-interplanetary-construction-3-requires-warpfield-science"].value then
  local warp_tech_3 = data.raw["technology"]["interplanetary-construction-3"]
  warp_tech_3.prerequisites = { "rabbasca-warpfield-science-pack" }
  table.insert(warp_tech_3.unit.ingredients, {"rabbasca-warpfield-science-pack", 1})
end