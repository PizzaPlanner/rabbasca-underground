data:extend {
    {
        type = "recipe-category",
        name = "rabbasca-warp-stabilizer",
    },
    {
        type = "recipe-category",
        name = "rabbasca-relics",
    },
    {
        type = "recipe-category",
        name = "rabbasca-relichunter",
    },
    {
        type = "recipe-category",
        name = "rabbasca-flooring",
    },
    {
        type = "item-subgroup",
        name = "rabbasca-warp-stabilizer",
        group = data.raw["item-group"]["rabbasca-extensions"] and "rabbasca-extensions" or "intermediate-products",
        order = "1[stabilizer]"
    },
    {
        type = "item-subgroup",
        name = "rabbasca-warp-stabilizer-functions",
        group = data.raw["item-group"]["rabbasca-extensions"] and "rabbasca-extensions" or nil,
        order = "2[stabilizer-functions]"
    },
    {
        type = "recipe",
        name = "rabbasca-lithium-amide-fission",
        icons = Rabbasca.icons({
            { proto = data.raw["item"]["rabbasca-lithium-amide"], scale = 0.5 },
            { proto = data.raw["item"]["lithium"], scale = 0.5, shift = {8, 3} },
            { proto = data.raw["fluid"]["ammonia"], scale = 0.5, shift = {3, 8} },
        }),
        enabled = false,
        energy_required = 12,
        ingredients = {
            { type = "item", name = "rabbasca-lithium-amide", amount = 4 },
            { type = "fluid", name = "sulfuric-acid", amount = 50 },
        },
        results = { 
            { type = "item", name = "lithium", amount = 5 },
            { type = "fluid", name = "ammonia", amount = 80 },
        },
        surface_conditions = { Rabbasca.only_underground() },
        category = "electromagnetics"
    },
    {
        type = "recipe",
        name = "rabbasca-beta-carotene-from-yumako",
        icons = Rabbasca.icons({
            { proto = data.raw["capsule"]["yumako-mash"], scale = 0.5, shift = {-3, -8} },
            { proto = data.raw["fluid"]["beta-carotene"] }
        }),
        enabled = false,
        energy_required = 6,
        ingredients = {
            { type = "item", name = "yumako-mash", amount = 50 },
            { type = "fluid", name = "harene-gas", amount = 5 },
        },
        results = { 
            { type = "fluid", name = "beta-carotene", amount = 75 },
        },
        category = "organic"
    },
    {
        type = "recipe",
        name = "rabbasca-warpfield-engine",
        enabled = false,
        energy_required = 14,
        ingredients = { 
            { type = "item", name = "engine-unit", amount = 1 }, 
            { type = "item", name = "electronic-circuit", amount = 10 }, 
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 12 },
            { type = "item", name = "rabbasca-warp-anomaly", amount = 25 },
            { type = "fluid", name = "fluoroketone-hot", amount = 60 },
        },
        results = { 
            { type = "item", name = "rabbasca-warpfield-engine", amount = 1 },
        },
        allow_productivity = true,
        auto_recycle = false,
        crafting_machine_tint =
        {
            primary = { 0.85, 0.42, 1 }
        },
        category = "metallurgy",
    },
    {
        type = "recipe",
        name = "rabbasca-warpfield-excitement-rod",
        enabled = false,
        energy_required = 8,
        result_is_always_fresh = true,
        ingredients = { 
            { type = "item", name = "rabbasca-warp-trace", amount = 10 },
            { type = "item", name = "rabbasca-lithium-amide", amount = 25 },
            { type = "fluid", name = "fluorine", amount = 100 } },
        results = { { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1 } },
        auto_recycle = false,
        crafting_machine_tint =
        {
            primary = { 0.85, 0.42, 1 }
        },
        stabilizer_config = { can_craft_for_free = true, freecraft_time_multiplier = 2 },
        category = "electromagnetics",
    },
    {
        type = "recipe",
        name = "rabbasca-reboot-stabilizer",
        enabled = true,
        energy_required = 20,
        hidden = true,
        hidden_in_factoriopedia = true,
        ingredients = { },
        results = { { type = "item", name = "rabbasca-reboot-stabilizer", amount = 1 } },
        category = "rabbasca-warp-stabilizer",
        order = "0",
        allow_productivity = false,
        stabilizer_config = { can_craft_for_free = true },
        result_is_always_fresh = true,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 0.95, 0.83, 0.14 }
        }
    },
    {
        type = "recipe",
        name ="rabbasca-stability-pylon",
        enabled = false,
        energy_required = 10,
        ingredients = {
            { type = "item", name = "rabbasca-powerspike", amount = 1 },
            { type = "item", name = "rabbasca-spatial-anchor", amount = 5 },
        },
        results = { { type = "item", name ="rabbasca-stability-pylon", amount = 1 } },
        category = "rabbasca-warp-stabilizer",
        order = "0",
        allow_productivity = false,
        stabilizer_config = { can_craft_for_free = true },
        result_is_always_fresh = true,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 0.95, 0.83, 0.14 }
        }
    },
    {
        type = "recipe",
        name = "rabbasca-collector-pylon",
        enabled = false,
        energy_required = 10,
        ingredients = {
            { type = "item", name = "rabbasca-powerspike",  amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-collector-pylon", amount = 1 } },
        category = "rabbasca-warp-stabilizer"
    },
    {
        type = "recipe",
        name = "rabbasca-warp-cell-recharging",
        enabled = false,
        energy_required = 10,
        ingredients = {
            { type = "item", name = "rabbasca-warp-anomaly", amount = 100 },
            { type = "item", name = "rabbasca-powerspike", amount = 2 },
        },
        results = { { type = "item", name = "rabbasca-warp-cell-recharging", amount = 1 } },
        category = "rabbasca-warp-stabilizer",
        order = "0",
        allow_productivity = false,
        stabilizer_config = { can_craft_for_free = true },
        result_is_always_fresh = true,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 0.95, 0.83, 0.14 }
        }
    },
    {
        type = "recipe",
        name = "rabbasca-ufo",
        enabled = true,
        energy_required = 40,
        ingredients = {
            { type = "item", name = "rabbasca-warpfield-engine", amount = 5 },
            { type = "item", name = "rabbasca-warp-core", amount = 5 },
            { type = "item", name = "radar", amount = 3 },
            { type = "item", name = "tesla-turret", amount = 1 },
        },
        result_is_always_fresh = true,
        results = { { type = "item", name = "rabbasca-ufo", amount = 1 } },
        category = "complex-machinery",
    },
    {
        type = "recipe",
        name = "rabbasca-abandon-stabilizer",
        enabled = true,
        energy_required = 45,
        hidden_in_factoriopedia = true,
        ingredients = { },
        results = { { type = "item", name = "rabbasca-abandon-stabilizer", amount = 1 } },
        category = "rabbasca-warp-stabilizer",
        order = "x",
        allow_productivity = false,
        stabilizer_config = { can_craft_for_free = true },
        result_is_always_fresh = true,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 1, 0, 0 }
        }
    },
    {
        type = "recipe",
        name = "rabbasca-stabilizer-warp-sequence",
        enabled = false,
        hidden_in_factoriopedia = true,
        energy_required = 10,
        result_is_always_fresh = true,
        -- ingredients = { { type = "item", name = "rabbasca-warp-cell", amount = 5 } },
        results = { { type = "item", name = "rabbasca-stabilizer-warp-sequence", amount = 1 } },
        allow_productivity = false,
        stabilizer_config = { }, -- cache energy_required
        crafting_machine_tint =
        {
            primary = { 0.85, 0.42, 1 }
        },
        category = "rabbasca-warp-stabilizer",
        order = "a",
        hide_from_signal_gui = false
    },
    {
        type = "recipe",
        name = "rabbasca-stabilizer-recharge",
        icons = Rabbasca.icons({
            { proto = data.raw["item"]["rabbasca-warp-cell-recharging"], scale = 0.5, shift = {8, 8} },
            { proto = data.raw["virtual-signal"]["signal-battery-full"], scale = 0.5, shift = {-8, -8} },
        }),
        enabled = true,
        hidden_in_factoriopedia = true,
        energy_required = 2,
        result_is_always_fresh = true,
        -- ingredients = { { type = "item", name = "rabbasca-warp-cell", amount = 5 } },
        results = { },
        allow_productivity = false,
        stabilizer_config = { }, -- cache energy_required
        crafting_machine_tint =
        {
            primary = { 1, 0.85, 0.75 }
        },
        category = "rabbasca-warp-stabilizer",
        order = "a",
        hide_from_signal_gui = false
    },
    {
        type = "recipe",
        name = "rabbasca-warp-trace",
        enabled = true,
        hidden_in_factoriopedia = false,
        energy_required = 2,
        result_is_always_fresh = true,
        ingredients = { { type = "item", name = "rabbasca-warp-anomaly", amount = 25 } },
        results = { 
            { type = "item", name = "rabbasca-progress-powerspike", amount = 1 }, -- Separate item to prevent wrong progress calculation when traces get removed early
            { type = "item", name = "rabbasca-warp-trace", amount = 10 }, -- When modifying amount, adapt powerspike progress in control.lua
        },
        main_product = "rabbasca-warp-trace",
        allow_productivity = true,
        auto_recycle = false,
        stabilizer_config = { }, -- cache energy_required
        crafting_machine_tint =
        {
            primary = { 0.5, 0.83, 1 }
        },
        category = "rabbasca-warp-stabilizer",
        order = "a",
    },
    {
        type = "recipe",
        name = "rabbasca-emergency-fuel",
        icons = Rabbasca.icons({
            { proto = data.raw["item"]["rabbasca-powerspike"], scale = 0.5, shift = {8, 8} },
            { proto = data.raw["tool"]["rabbasca-warp-trace"] },
            { proto = data.raw["virtual-signal"]["signal-alert"], scale = 0.5, shift = {-8, -8} },
        }),
        enabled = true,
        energy_required = 30,
        result_is_always_fresh = true,
        ingredients = { { type = "item", name = "rabbasca-powerspike", amount = 1 } },
        results = { 
            { type = "item", name = "rabbasca-warp-trace", amount = 250 }
        },
        -- main_product = "rabbasca-warp-trace",
        allow_productivity = true,
        auto_recycle = false,
        stabilizer_config = { }, -- cache energy_required
        crafting_machine_tint =
        {
            primary = { 0.2, 0.33, 1 }
        },
        category = "rabbasca-warp-stabilizer",
        order = "z[emergency-fuel]",
    },
    {
        type = "recipe",
        name = "rabbasca-amplify-anomaly",
        enabled = false,
        energy_required = 2,
        result_is_always_fresh = true,
        reset_freshness_on_craft = true,
        ingredients = { { type = "item", name = "rabbasca-warp-trace", amount = 5 } },
        allow_productivity = false,
        results = { { type = "item", name = "rabbasca-destabilize-warpfield", amount = 1 } },
        surface_conditions = { Rabbasca.only_underground(true) },
        crafting_machine_tint =
        {
            primary = { 0.51, 0.24, 1 }
        },
        category = "rabbasca-remote"
    },
    {
        type = "recipe",
        name = "rabbasca-coordinate-system",
        enabled = false,
        energy_required = 5,
        ingredients = {
            { type = "item",  name = "rabbasca-warp-anomaly", amount = 10 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod",  amount = 2 },
            { type = "fluid", name = "ammonia",  amount = 200 },
            { type = "item", name = "holmium-plate",  amount = 17 },
        },
        results = { 
            { type = "item", name = "rabbasca-coordinate-system", amount = 3 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.8 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.8 },
        },
        main_product = "rabbasca-coordinate-system",
        surface_conditions = { Rabbasca.only_underground(true) },
        category = "cryogenics"
    },
    {
        type = "recipe",
        name = "rabbasca-quantum-device",
        enabled = false,
        energy_required = 7,
        ingredients = {
            { type = "item", name = "rabbasca-warp-anomaly", amount = 30 },
            { type = "item", name = "rabbasca-warp-trace", amount = 5 },
            { type = "item", name = "rabbasca-warpfield-engine", amount = 2 },
            { type = "item", name = "haronite-plate", amount = 1 },
        },
        results = {
            { type = "item", name = "rabbasca-quantum-device", amount = 1 },
        },
        allow_productivity = true,
        category = "metallurgy",
        surface_conditions = { Rabbasca.only_underground(true) },
    },
    {
        type = "recipe",
        name = "rabbasca-spacetime-sensor",
        enabled = false,
        energy_required = 12,
        ingredients = {
            { type = "fluid", name = "harene-gas", amount = 150 },
            { type = "fluid", name = "fluorine", amount = 75 },
            { type = "item", name = "carbon-fiber", amount = 5 },
            { type = "item", name = "display-panel", amount = 1 },
        },
        results = {
            { type = "item", name = "rabbasca-spacetime-sensor", amount = 1 },
        },
        allow_productivity = true,
        category = "electromagnetics",
    },
    {
        type = "recipe",
        name = "rabbasca-warp-core",
        enabled = true,
        auto_recycle = false,
        energy_required = 5,
        ingredients = {
            { type = "item", name = "rabbasca-quantum-device", amount = 1 },
            { type = "item", name = "rabbasca-spatial-anchor", amount = 1 },
            { type = "item", name = "rabbasca-coordinate-system", amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-warp-core", amount = 5 } },
        category = "electromagnetics"
    },
    {
        type = "recipe",
        name = "rabbasca-warp-tech-analyzer",
        enabled = false,
        energy_required = 10,
        ingredients = {
            { type = "item", name = "lab", amount = 1 },
            { type = "item", name = "rabbasca-warpfield-engine",  amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-warp-tech-analyzer", amount = 1 } },
        category = "crafting"
    },
    {
        type = "recipe",
        name = "rabbasca-fuel-remote",
        enabled = true,
        energy_required = 3,
        ingredients = {
            { type = "item", name = "rabbasca-warpfield-excitement-rod",  amount = 2 },
            { type = "item", name = "rabbasca-warp-core",  amount = 5 },
            { type = "item", name = "steel-chest",  amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-fuel-remote", amount = 1 } },
        category = "crafting"
    },
    {
        type = "recipe",
        name = "rabbasca-relicary-remote",
        enabled = false,
        energy_required = 3,
        ingredients = {
            { type = "item", name = "storage-chest",   amount = 5 },
            { type = "item", name = "rabbasca-warpfield-engine",   amount = 5 },
            { type = "item", name = "rabbasca-spacetime-sensor",   amount = 1 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 5 },
        },
        results = { { type = "item", name = "rabbasca-relicary-remote", amount = 1 } },
        category = "crafting"
    },
    {
        type = "recipe",
        name = "rabbasca-floor-stability-work",
        icon = data.raw["virtual-signal"]["signal-clockwise-circle-arrow"].icon,
        enabled = true,
        hidden_in_factoriopedia = true,
        energy_required = 300,
        ingredients = { },
        results = { },
        category = "rabbasca-flooring",
        result_is_always_fresh = true,
        crafting_machine_tint = { primary = { 0.88, 0.52, 0 } },
    },
    {
        type = "recipe",
        name = "rabbasca-relocate-floorthing",
        enabled = true,
        hidden_in_factoriopedia = true,
        energy_required = 30,
        ingredients = { },
        results = { { type= "item", name = "rabbasca-relocate-floorthing", amount = 1 } },
        category = "rabbasca-flooring",
        result_is_always_fresh = true,
        crafting_machine_tint = { primary = { 0.53, 0.24, 0.8 } },
    },
    {
        type = "recipe",
        name = "rabbasca-hunt-relicaries",
        icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon.png",
        icon_size = 64,
        enabled = true,
        energy_required = 12,
        ingredients = {
            { type = "item", name = "rabbasca-warp-anomaly", amount = 60 },
        },
        results = { },
        category = "rabbasca-relichunter"
    },
    {
        type = "recipe",
        name = "rabbasca-relichunter",
        icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon.png",
        icon_size = 64,
        enabled = false,
        energy_required = 12,
        ingredients = {
            { type = "item", name = "rabbasca-warp-anomaly", amount = 20 },
            { type = "item", name = "rabbasca-warpfield-engine", amount = 5 },
            { type = "item", name = "tungsten-plate", amount = 12 },
            { type = "item", name = "iron-gear-wheel", amount = 30 },
        },
        results = { { type = "item", name = "rabbasca-relichunter", amount = 1 }, },
        category = "crafting"
    },
    {
        type = "recipe",
        name = "rabbasca-summon-ufo",
        enabled = false,
        energy_required = 10,
        allow_productivity = false,
        result_is_always_fresh = true,
        hide_from_player_crafting = false,
        ingredients = {
            { type = "item", name = "rabbasca-spacetime-sensor", amount = 1 },
        },
        results = { 
            { type = "item", name = "rabbasca-summon-ufo", amount = 1 },
            { type = "item", name = "rabbasca-spacetime-sensor", amount = 1, probability = 0.6, ignored_by_productivity = 1 }, },
        main_product = "rabbasca-summon-ufo",
        category = "crafting"
    },
}

Rabbasca.create_vault_recipe("rabbasca-locate-stabilizer", {
  icons = {
    {icon = "__Krastorio2Assets__/icons/entities/stabilizer-charging-station.png", icon_size = 64},
    {icon = data.raw["item"]["rabbasca-warp-pylon"].icon, icon_size = 64, shift = {-8, 8}, scale = 0.4},
    {icon = data.raw["planet"]["rabbasca-underground"].icon, icon_size = 64, shift = {8, 8}, scale = 0.4},
  },
  ingredients = {
      { type = "item", name = "rabbasca-warp-pylon", amount = 1 },
      { type = "item", name = "rabbasca-spacetime-sensor", amount = 10 },
  },
  results = { 
      { type = "item", name = "rabbasca-locate-stabilizer", amount = 1 },
  },
  energy_required = 120,
  allow_productivity = false,
})

data:extend {
    {
        type = "recipe",
        name = "rabbasca-spatial-anchor",
        enabled = true,
        energy_required = 17,
        ingredients = {
            { type = "item", name = "superconductor", amount = 1 },
            { type = "item", name = "lithium-plate", amount = 5 },
            { type = "item", name = "harenic-stabilizer", amount = 1 },
            { type = "fluid", name = "harene-gas", amount = 200 },
        },
        results = { { type = "item", name = "rabbasca-spatial-anchor", amount = 2 } },
        category = "electromagnetics"
    },
    {
        type = "recipe",
        name = "rabbasca-twisted-knowledge",
        icons = Rabbasca.icons({
            { proto = data.raw["furnace"]["rabbasca-relicary"] },
            { proto = data.raw["blueprint-book"]["blueprint-book"], scale = 0.5, shift = {8, 8} },
        }),
        enabled = true,
        energy_required = 0.2,
        ingredients = {
            { type = "item", name = "beta-carotene-barrel",   amount = 1 },
        },
        results = { 
            { type = "item", name = "rabbasca-twisted-knowledge", amount = 1 },
        },
        main_product = "rabbasca-twisted-knowledge",
        category = "rabbasca-relics"
    },
    {
        type = "recipe",
        name = "rabbasca-uncanny-knowledge",
        icons = Rabbasca.icons({
            { proto = data.raw["furnace"]["rabbasca-relicary"] },
            { proto = data.raw["blueprint-book"]["blueprint-book"], scale = 0.5, shift = {8, 8}, tint = { 1, 0.5, 0.3 } },
        }),
        enabled = true,
        energy_required = 0.2,
        ingredients = {
            { type = "item", name = "rabbasca-warp-core",   amount = 1 },
        },
        results = { 
            { type = "item", name = "rabbasca-uncanny-knowledge", amount = 1, probability = 0.85 },
        },
        category = "rabbasca-relics"
    },
}