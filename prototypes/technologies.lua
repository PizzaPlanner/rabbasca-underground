local function make_research_dummy(item)
  if not data.raw["recipe"][item.name] then
    data:extend {
      {
        name = item.name,
        type = "recipe",
        enabled = true,
        hidden_in_factoriopedia = true,
        hide_from_player_crafting = true,
        energy_required = item.energy or 30,
        ingredients = item.ingredients or {
            { type = "item", name = "rabbasca-restored-knowledge", amount = 1 },
        },
        results = { 
            { type = "item", name = item.name, amount = 1 },
        },
        auto_recycle = false,
        categories = { "rabbasca-relichunter" }
      },
      util.merge {
      {
          type = "item",
          icons = Rabbasca.icons({{ proto = data.raw["item"]["rabbasca-relichunter"] }}),
          flags = { "ignore-spoil-time-modifier", "not-stackable", "only-in-cursor" },
          hidden = true,
          hidden_in_factoriopedia = true,
          auto_recycle = false,
          stack_size = 1,
          spoil_ticks = 1,
      },
      item }
    }
  end
  return
  {
      type = "craft-item",
      item = item.name,
      count = item.count or 100
  }
end

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
        type = "unlock-recipe",
        recipe = "rabbasca-hidden-unlocks-underground"
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
    name = "rabbasca-warp-anomaly",
    prerequisites = { "rabbasca-underground" },
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
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
    name = "rabbasca-anomaly-studies",
    icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warpfield-science-pack" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-amplify-anomaly"
      },
    },
    unit = {
      time = 60,
      count = 400,
      ingredients = {
        {"rabbasca-warpfield-science-pack", 1},
      }
    },
    -- research_trigger = make_research_dummy({
    --   name = "rabbasca-research-anomalies",
    --   ingredients = {
    --     { type = "item", name = "rabbasca-restored-knowledge", amount = 2 },
    --     { type = "item", name = "rabbasca-warp-core", amount = 1 },
    --   }
    -- })
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
      entities = { "rabbasca-lithium-amide" }
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
      entities = { "rabbasca-yumako-mashup" }
    }
},
{
    type = "technology",
    name = "rabbasca-warpfield-science-pack",
    icon = "__rabbasca-assets__/graphics/recolor/technologies/warp-science-pack-big.png",
    icon_size = 256,
    prerequisites = { "rabbasca-warp-technology-analysis-2" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-restored-knowledge"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-science-pack"
      },
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warpfield-science-pack-wi-download"
      },
    },
    ignore_tech_cost_multiplier = true,
    research_trigger =
    {
        type = "craft-item",
        item = "rabbasca-obscure-theories",
        count = 5
    }
},
{
    type = "technology",
    name = "rabbasca-warp-technology-analysis-2",
    icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-anomaly" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-relichunter"
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
    icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
    prerequisites = { "rabbasca-warpfield-science-pack" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-relicary-remote"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 60,
      count = 100,
      ingredients = {
        {"rabbasca-warpfield-science-pack", 1},
      }
    },
    -- research_trigger = make_research_dummy({
    --   name = "rabbasca-research-access-devices",
    --   count = 100,
    --   ingredients = {
    --     { type = "item", name = "rabbasca-restored-knowledge", amount = 1 },
    --     { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1 },
    --   }
    -- })
},
{
    type = "technology",
    name = "rabbasca-nearby-access",
    icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
    prerequisites = { "rabbasca-relicary-remote", "rabbasca-warp-core" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-fuel-remote"
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
    -- research_trigger = make_research_dummy({
    --   name = "rabbasca-research-access-devices",
    --   count = 200,
    -- })
},
{
    type = "technology",
    name = "rabbasca-quantum-device",
    icons = Rabbasca.icons({ proto = data.raw["item"]["rabbasca-quantum-device"] }),
    prerequisites = { "rabbasca-warpfield-science-pack" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-quantum-device"
      },
    },
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 60,
      count = 50,
      ingredients = {
        {"rabbasca-warpfield-science-pack", 1},
      }
    },
    -- research_trigger = make_research_dummy({
    --   name = "rabbasca-research-warp-core",
    --   count = 50,
    -- })
},
{
    type = "technology",
    name = "rabbasca-warp-core",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-quantum-device" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-warp-core-from-underground"
      },
    },
    unit = {
      time = 60,
      count = 250,
      ingredients = {
        {"rabbasca-warpfield-science-pack", 1},
      }
    },
    -- research_trigger = make_research_dummy({
    --   name = "rabbasca-research-warp-core",
    --   count = 100,
    -- })
},
{
    type = "technology",
    name = "rabbasca-self-made-warp-pylon",
    icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-big.png",
    icon_size = 640,
    prerequisites = { "rabbasca-warp-core" },
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
    -- research_trigger = make_research_dummy({
    --   name = "rabbasca-research-warp-pylon",
    --   ingredients = {
    --     { type = "item", name = "rabbasca-restored-knowledge", amount = 2 },
    --     { type = "item", name = "rabbasca-warp-core", amount = 1 },
    --   }
    -- })
},
{
    type = "technology",
    name = "rabbasca-ufo",
    icon = "__rabbasca-assets__/graphics/recolor/icons/warpotron.png",
    icon_size = 64,
    prerequisites = { "rabbasca-warp-core", "tesla-weapons" },
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
    -- research_trigger = make_research_dummy({
    --   name = "rabbasca-research-warpotron",
    --   ingredients = { 
    --     { type = "item", name = "rabbasca-restored-knowledge", amount = 2 },
    --     { type = "item", name = "rabbasca-warp-core", amount = 1 },
    --   }
    -- })
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
        recipe = "rabbasca-restored-knowledge",
        change = 0.1
      },
      {
        type = "change-recipe-productivity",
        recipe = "rabbasca-obscure-theories",
        change = 0.2
      }
    },
    max_level = "infinite",
    ignore_tech_cost_multiplier = true,
    unit = {
      time = 60,
      count_formula = "100 + 25 * L * L",
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
    prerequisites = { "rabbasca-warp-core", "interplanetary-construction-3", "speed-module-3" },
    effects = {
      {
        type = "unlock-recipe",
        recipe = "rabbasca-madness-module"
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
}

local warp_tech_3 = data.raw["technology"]["interplanetary-construction-3"]
warp_tech_3.prerequisites = { "rabbasca-warpfield-science-pack" }
table.insert(warp_tech_3.unit.ingredients, {"rabbasca-warpfield-science-pack", 1})