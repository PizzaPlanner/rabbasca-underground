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
        group = "rabbasca-extensions" or "intermediate-products",
        order = "1[stabilizer]"
    },
    {
        type = "item-subgroup",
        name = "rabbasca-ug-processes",
        group = "intermediate-products",
        order = "l-rabbasca-ug"
    },
    {
        type = "item-subgroup",
        name = "rabbasca-events",
        group = "rabbasca-extensions",
        order = "2[stabilizer-functions]"
    },
    {
        type = "recipe",
        name = "rabbasca-plastic-from-petroleum-gas",
        icons = Rabbasca.icons({
            { proto = data.raw["item"]["plastic-bar"] },
            { proto = data.raw["fluid"]["petroleum-gas"], shift = {-8, 8}, scale = 0.5 },
        }),
        enabled = false,
        hide_from_signal_gui = false,
        hide_from_player_crafting = true,
        energy_required = 1,
        ingredients = { { type = "fluid", name = "petroleum-gas", amount = 40 } },
        allow_productivity = true,
        results = { { type = "item", name = "plastic-bar", amount = 2 } },
        surface_conditions = { Rabbasca.only_underground(false) },
        crafting_machine_tint =
        {
            primary = { 0.7, 0.71, 0.72 }
        },
        subgroup = "rabbasca-ug-processes",
        order = "b[parts]-a[plastic]",
        categories = { "cryogenics" }
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
        categories = { "electromagnetics" },
        subgroup = "rabbasca-ug-processes",
        order = "a[resources]-a[amide-fission]"
    },
    {
        type = "recipe",
        name = "rabbasca-beta-carotene-from-yumako",
        hide_from_signal_gui = false,
        icons = Rabbasca.icons({
            { proto = data.raw["capsule"]["yumako-mash"], scale = 0.7, shift = {-6, -8} },
            { icon = "__rabbasca-assets__/graphics/recolor/icons/beta-carotene.png" },
        }),
        enabled = false,
        energy_required = 6,
        ingredients = {
            { type = "item", name = "yumako-mash", amount = 40 },
            { type = "fluid", name = "harene-gas", amount = 15 },
        },
        results = { 
            { type = "fluid", name = "beta-carotene", amount = 75 },
        },
        categories = { "organic" },
        subgroup = "rabbasca-ug-processes",
        order = "a[resources]-c[carotene-alt]"
    },
    {
        type = "recipe",
        name = "rabbasca-warpfield-engine",
        enabled = false,
        energy_required = 14,
        ingredients = { 
            { type = "item", name = "engine-unit", amount = 1 }, 
            { type = "item", name = "electronic-circuit", amount = 10 }, 
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 4 },
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
        categories = { "metallurgy" },
    },
    {
        type = "recipe",
        name = "rabbasca-warpfield-excitement-rod",
        enabled = false,
        energy_required = 8,
        ingredients = { 
            { type = "item", name = "rabbasca-warp-trace", amount = 10 },
            { type = "item", name = "rabbasca-lithium-amide", amount = 25 },
            { type = "fluid", name = "fluorine", amount = 100 } },
        results = { { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1 } },
        auto_recycle = false,
        allow_productivity = true,
        crafting_machine_tint =
        {
            primary = { 0.85, 0.42, 1 }
        },
        categories = { "electromagnetics" },
    },
    {
        type = "recipe",
        name ="rabbasca-stability-pylon",
        enabled = false,
        energy_required = 20,
        ingredients = {
            { type = "item", name = "rabbasca-powerspike", amount = 1 },
            { type = "item", name = "harenic-stabilizer",amount = 5 },
            { type = "item", name = "carbon-fiber",amount = 5 },
        },
        results = { { type = "item", name ="rabbasca-stability-pylon", amount = 1, affected_by_quality = false } },
        categories = { "rabbasca-warp-stabilizer" },
        order = "0",
        overload_multiplier = 1,
        allow_inserter_overload = false,
        hide_from_player_crafting = true,
        allow_productivity = false,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 0.95, 0.83, 0.14 }
        }
    },
    {
        type = "recipe",
        name = "rabbasca-collector-pylon",
        enabled = false,
        energy_required = 20,
        ingredients = {
            { type = "item", name = "rabbasca-powerspike",  amount = 1 },
            { type = "item", name = "superconductor", amount = 20 },
        },
        results = { { type = "item", name = "rabbasca-collector-pylon", amount = 1, affected_by_quality = false } },
        categories = { "rabbasca-warp-stabilizer" },
        overload_multiplier = 1,
        allow_inserter_overload = false,
        auto_recycle = false,
        hide_from_player_crafting = true,
    },
    {
        type = "recipe",
        name = "rabbasca-warp-cell-recharging",
        enabled = false,
        energy_required = 20,
        ingredients = {
            { type = "item", name = "rabbasca-warp-anomaly", amount = 100 },
            { type = "item", name = "rabbasca-restored-knowledge", amount = 1 },
            { type = "item", name = "rabbasca-powerspike", amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-warp-cell-recharging", amount = 1, always_fresh = true, affected_by_quality = false } },
        categories = { "rabbasca-warp-stabilizer" },
        order = "0",
        overload_multiplier = 1,
        allow_inserter_overload = false,
        hide_from_player_crafting = true,
        allow_productivity = false,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 0.95, 0.83, 0.14 }
        },
    },
    {
        type = "recipe",
        name = "rabbasca-powershard",
        enabled = false,
        energy_required = 15,
        ingredients = {
            { type = "item", name = "rabbasca-powerspike", amount = 1 },
        },
        results = { 
            { type = "item", name = "rabbasca-powershard", amount = 5 },
            { type = "item", name = "rabbasca-powerspike-weak", amount = 1, affected_by_quality = false, always_fresh = true, percent_spoiled = 0.5, ignored_by_productivity = 1 },
         },
        categories = { "rabbasca-warp-stabilizer" },
        main_product = "rabbasca-powershard",
        subgroup = "rabbasca-events",
        order = "a[stabilizer]-n",
        overload_multiplier = 1,
        allow_inserter_overload = false,
        hide_from_player_crafting = true,
        allow_productivity = false,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 0.95, 0.83, 0.14 }
        },
    },
    {
        type = "recipe",
        name = "rabbasca-ufo",
        enabled = false,
        energy_required = 40,
        ingredients = {
            { type = "item", name = "rabbasca-warpfield-engine", amount = 5 },
            { type = "item", name = "rabbasca-warp-core", amount = 5 },
            { type = "item", name = "radar", amount = 3 },
            { type = "item", name = "tesla-turret", amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-ufo", amount = 1, always_fresh = true } },
        categories = { "complex-machinery" },
    },
    {
        type = "recipe",
        name = "rabbasca-abandon-stabilizer",
        icons = Rabbasca.icons({
            { proto = data.raw["virtual-signal"]["signal-explosion"] }
        }),
        enabled = false,
        hide_from_player_crafting = true,
        energy_required = 45,
        raise_on_crafted = true,
        categories = { "rabbasca-warp-stabilizer" },
        subgroup = "rabbasca-events",
        order = "a[stabilizer]-x",
        allow_productivity = false,
        allow_speed = false,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 1, 0, 0 }
        }
    },
    {
        type = "recipe",
        name = "rabbasca-stabilizer-warp-sequence",
        icons = Rabbasca.icons({{ icon = "__rabbasca-assets__/graphics/icons/warp.png" }}),
        enabled = false,
        hide_from_player_crafting = true,
        raise_on_crafted = true,
        energy_required = 10,
        allow_productivity = false,
        crafting_machine_tint =
        {
            primary = { 0.85, 0.42, 1 }
        },
        categories = { "rabbasca-warp-stabilizer" },
        subgroup = "rabbasca-events",
        order = "a[stabilizer]-a",
        hide_from_signal_gui = false
    },
    {
        type = "recipe",
        name = "rabbasca-warp-trace",
        enabled = false,
        hidden_in_factoriopedia = false,
        hide_from_player_crafting = true,
        energy_required = 2,
        ingredients = { { type = "item", name = "rabbasca-warp-anomaly", amount = 25 } },
        results = { 
             -- Separate item to prevent wrong progress calculation when traces get removed early
            { type = "item", name = "rabbasca-progress-powerspike", amount = 1, always_fresh = true, show_details_in_recipe_tooltip = false, affected_by_quality = false },
            { type = "item", name = "rabbasca-warp-trace", amount = 10, always_fresh = true, affected_by_quality = false },
        },
        maximum_productivity = 24,
        main_product = "rabbasca-warp-trace",
        allow_productivity = true,
        auto_recycle = false,
        crafting_machine_tint =
        {
            primary = { 0.5, 0.83, 1 }
        },
        categories = { "rabbasca-warp-stabilizer" },
        order = "a",
    },
    {
        type = "recipe",
        name = "rabbasca-emergency-fuel",
        hide_from_signal_gui = false,
        icons = Rabbasca.icons({
            { proto = data.raw["item"]["rabbasca-warp-trace"] },
            { icon = "__base__/graphics/icons/signal/signal-battery-full.png", icon_size = 64, shift = { 8, 8 }, scale = 0.5 }
        }),
        enabled = false,
        hide_from_player_crafting = true,
        energy_required = 30,
        ingredients = { { type = "item", name = "rabbasca-powerspike", amount = 1 } },
        results = { 
            { type = "item", name = "rabbasca-warp-trace", amount = 150, always_fresh = true, affected_by_quality = false },
            { type = "item", name = "rabbasca-powerspike-weak", amount = 1, affected_by_quality = false, always_fresh = true, percent_spoiled = 0, ignored_by_productivity = 1 },
        },
        overload_multiplier = 1,
        allow_inserter_overload = false,
        -- main_product = "rabbasca-warp-trace",
        allow_productivity = true,
        auto_recycle = false,
        crafting_machine_tint =
        {
            primary = { 0.2, 0.33, 1 }
        },
        categories = { "rabbasca-warp-stabilizer" },
        subgroup = "rabbasca-events",
        order = "a[stabilizer]-m",
    },
    {
        type = "recipe",
        name = "rabbasca-amplify-anomaly",
        enabled = false,
        hide_from_player_crafting = true,
        can_set_quality = false,
        energy_required = 1,
        ingredients = { { type = "item", name = "rabbasca-warp-trace", amount = 5 } },
        allow_productivity = false,
        results = { { type = "item", name = "rabbasca-amplify-anomaly", amount = 1, always_fresh = true, show_details_in_recipe_tooltip = false } },
        surface_conditions = { Rabbasca.only_underground(true) },
        crafting_machine_tint =
        {
            primary = { 0.51, 0.24, 1 }
        },
        categories = { "rabbasca-remote" }
    },
    {
        type = "recipe",
        name = "rabbasca-quantum-device",
        enabled = false,
        energy_required = 7,
        ingredients = {
            { type = "item", name = "lithium-plate", amount = 4 },
            { type = "item", name = "rabbasca-warp-trace", amount = 5 },
            { type = "item", name = "rabbasca-warpfield-engine", amount = 2 },
            { type = "item", name = "haronite-plate", amount = 3 },
        },
        results = {
            { type = "item", name = "rabbasca-quantum-device", amount = 1 },
        },
        allow_productivity = true,
        categories = { "metallurgy" },
        surface_conditions = { Rabbasca.only_underground(true) },
    },
    {
        type = "recipe",
        name = "rabbasca-spacetime-sensor",
        enabled = false,
        energy_required = 12,
        ingredients = {
            { type = "fluid", name = "harene", amount = 5 },
            { type = "fluid", name = "fluorine", amount = 75 },
            { type = "item", name = "carbon-fiber", amount = 5 },
            { type = "item", name = "display-panel", amount = 1 },
        },
        results = {
            { type = "item", name = "rabbasca-spacetime-sensor", amount = 1 },
        },
        allow_productivity = true,
        categories = { "electromagnetics" },
    },
    {
        type = "recipe",
        name = "rabbasca-warpfield-science-pack",
        enabled = false,
        energy_required = 35,
        ingredients = {
            { type = "item", name = "rabbasca-spacetime-sensor", amount = 1 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 4 },
            { type = "item", name = "rabbasca-warp-core", amount = 1 },
            { type = "item", name = "rabbasca-restored-knowledge", amount = 10 },
        },
        results = {
            { type = "item", name = "rabbasca-warpfield-science-pack", amount = 8 },
        },
        main_product = "rabbasca-warpfield-science-pack",
        allow_productivity = true,
        categories = { "crafting-with-fluid" },
    },
    {
        type = "recipe",
        name = "rabbasca-warpfield-science-pack-wi-upload",
        icons = Rabbasca.icons({
            { icon = "__rabbasca-assets__/graphics/recolor/icons/item-upload-slot.png", icon_size = 64 },
            { icon = "__rabbasca-assets__/graphics/recolor/icons/warp-science-pack.png", icon_size = 64, scale = 0.5, shift = {0, 3} }
        }),
        enabled = false,
        hide_from_player_crafting = true,
        energy_required = 2,
        ingredients = {
            { type = "item", name = "rabbasca-warpfield-science-pack", amount = 10 },
        },
        raise_on_crafted = true,
        overload_multiplier = 10,
        results = { },
        allow_productivity = false,
        can_set_quality = true,
        order = "z[upload]",
        subgroup = "rabbasca-remote-warping",
        categories = { "rabbasca-remote" },
    },          
    {
        type = "recipe",
        name = "rabbasca-supercharged-module",
        enabled = false,
        energy_required = 30,
        ingredients = {
            { type = "fluid", name = "harene", amount = 50 },
            { type = "item", name = "rabbasca-powerspike", amount = 1 },
            { type = "item", name = "speed-module-3", amount = 6 },
        },
        auto_recycle = false,
        results = {
            { type = "item", name = "rabbasca-supercharged-module", amount = 1 },
        },
        surface_conditions = { Rabbasca.only_underground(true) },
        allow_productivity = true,
        categories = { "crafting-with-fluid" },
    },
    {
        type = "recipe",
        name = "rabbasca-warp-core",
        enabled = false,
        auto_recycle = false,
        energy_required = 5,
        ingredients = {
            { type = "item", name = "rabbasca-quantum-device", amount = 1 },
            { type = "item", name = "superconductor", amount = 4 },
            { type = "item", name = "rabbasca-warp-anomaly", amount = 50 },
            { type = "item", name = "rabbasca-restored-knowledge", amount = 3 },
        },
        results = { 
            { type = "item", name = "rabbasca-warp-core", amount = 5, always_fresh = true },
        },
        surface_conditions = { Rabbasca.only_underground(true) },
        categories = { "electromagnetics" },
        subgroup = "rabbasca-processes",
        order = "w[warp]-a[warp-core]"
    },
    {
        type = "recipe",
        name = "rabbasca-relicary-remote",
        enabled = false,
        energy_required = 3,
        ingredients = {
            { type = "item", name = "storage-chest",   amount = 2 },
            { type = "item", name = "rabbasca-warpfield-engine",   amount = 1 },
            { type = "item", name = "rabbasca-spacetime-sensor",   amount = 1 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 5 },
        },
        results = { { type = "item", name = "rabbasca-relicary-remote", amount = 1 } },
        categories = { "crafting" }
    },
    {
        type = "recipe",
        name = "rabbasca-floor-stability-work",
        icon = data.raw["virtual-signal"]["signal-clockwise-circle-arrow"].icon,
        enabled = true,
        hidden_in_factoriopedia = true,
        hide_from_player_crafting = true,
        energy_required = 300,
        ingredients = { },
        results = { },
        categories = { "rabbasca-flooring" },
        crafting_machine_tint = { primary = { 0.88, 0.52, 0 } },
    },
    {
        type = "recipe",
        name = "rabbasca-relocate-floorthing",
        enabled = true,
        hidden_in_factoriopedia = true,
        hide_from_player_crafting = true,
        energy_required = 30,
        ingredients = { },
        results = { { type= "item", name = "rabbasca-relocate-floorthing", amount = 1, always_fresh = true, show_details_in_recipe_tooltip = false } },
        categories = { "rabbasca-flooring" },
        crafting_machine_tint = { primary = { 0.53, 0.24, 0.8 } },
    },
    {
        type = "recipe",
        name = "rabbasca-hunt-relicaries",
        icons = Rabbasca.icons({
            { proto = data.raw["furnace"]["rabbasca-relicary"], scale = 1 },
            { proto = data.raw["virtual-signal"]["signal-map-marker"], scale = 0.5, shift = {8, 8} },
        }),
        hide_from_signal_gui = false,
        enabled = false,
        hide_from_player_crafting = true,
        can_set_quality = false,
        energy_required = 10,
        auto_recycle = false,
        ingredients = { { type = "item", name = "rabbasca-lithium-amide", amount = 5 } },
        results = { { type = "item", name = "rabbasca-progress-hunt", amount = 1, always_fresh = true, show_details_in_recipe_tooltip = false} },
        categories = { "rabbasca-relichunter" },
        subgroup = "rabbasca-events",
        order = "h[hunter]-a[relics]"
    },
    {
        type = "recipe",
        name = "rabbasca-hunt-anomalies",
        icons = Rabbasca.icons({
            { proto = data.raw["resource"]["rabbasca-warp-anomaly"] },
            { proto = data.raw["virtual-signal"]["signal-map-marker"], scale = 0.5, shift = {8, 8} },
        }),
        hide_from_signal_gui = false,
        enabled = false,
        hide_from_player_crafting = true,
        can_set_quality = false,
        energy_required = 12,
        auto_recycle = false,
        ingredients = { { type = "item", name = "rabbasca-lithium-amide", amount = 5 } },
        results = { { type = "item", name = "rabbasca-progress-hunt", amount = 1, always_fresh = true, show_details_in_recipe_tooltip = false } },
        categories = { "rabbasca-relichunter" },
        subgroup = "rabbasca-events",
        order = "h[hunter]-b[anomalies]"
    },
    {
        type = "recipe",
        name = "rabbasca-relichunter",
        icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon.png",
        icon_size = 64,
        enabled = false,
        energy_required = 12,
        hide_from_player_crafting = true,
        ingredients = {
            { type = "item", name = "rabbasca-warp-anomaly", amount = 20 },
            { type = "item", name = "rabbasca-warpfield-engine", amount = 5 },
            { type = "item", name = "tungsten-plate", amount = 12 },
            { type = "item", name = "iron-gear-wheel", amount = 30 },
        },
        results = { { type = "item", name = "rabbasca-relichunter", amount = 1 }, },
        categories = { "complex-machinery" }
    },
    {
        type = "recipe",
        name = "rabbasca-summon-ufo",
        enabled = false,
        energy_required = 10,
        allow_productivity = false,
        hide_from_player_crafting = false,
        ingredients = {
            { type = "item", name = "rabbasca-spacetime-sensor", amount = 1 },
        },
        results = { 
            { type = "item", name = "rabbasca-summon-ufo", amount = 1, always_fresh = true, show_details_in_recipe_tooltip = false },
            { type = "item", name = "rabbasca-spacetime-sensor", amount = 1, independent_probability = 0.6, ignored_by_productivity = 1 }, },
        main_product = "rabbasca-summon-ufo",
        categories = { "crafting" }
    },
}

Rabbasca.create_vault_recipe("rabbasca-warpfield-science-pack-wi-download", {
  icons = Rabbasca.icons({
    { icon = "__Krastorio2Assets__/icons/entities/stabilizer-charging-station.png", icon_size = 64 },
    { icon = "__rabbasca-assets__/graphics/recolor/icons/warp-science-pack.png", icon_size = 64, shift = {8, 8}, scale = 0.75 },
  }),
  ingredients = { },
  results = { { type = "item", name = "rabbasca-warpfield-science-pack", amount = 0 } },
  raise_on_crafted = true,
  energy_required = 10,
  allow_productivity = false,
  allow_quality = false,
  can_set_quality = true,
  subgroup = "rabbasca-vault-extraction",
  order = "v[vault]-f[warpfield-science]",
})

Rabbasca.create_vault_recipe("rabbasca-locate-stabilizer", {
  icons = Rabbasca.icons({
    { proto = data.raw["planet"]["rabbasca-underground"] },
    { proto = data.raw["virtual-signal"]["signal-map-marker"], scale = 0.5, shift = {8, 8} },
  }),
  ingredients = {
      { type = "item", name = "rabbasca-warp-pylon", amount = 1 },
      { type = "item", name = "rabbasca-spacetime-sensor", amount = 5 },
  },
  results = { 
      { type = "item", name = "rabbasca-locate-stabilizer", amount = 1, shared_probability = { min = 0, max = 0.2 }, always_fresh = true, show_details_in_recipe_tooltip = false },
      { type = "item", name = "rabbasca-warp-pylon", amount = 1, shared_probability = { min = 0.2, max = 1 }, affected_by_quality = false, show_details_in_recipe_tooltip = false },
  },
  can_set_quality = false,
  energy_required = 60,
  allow_quality = false,
  allow_productivity = false,
  order = "z[effects]-s[stabilizer]"
})

data:extend {
    {
        type = "recipe",
        name = "rabbasca-obscure-theories",
        enabled = false,
        hide_from_player_crafting = true,
        energy_required = 0.5,
        ingredients = {
            { type = "item", name = "beta-carotene-barrel",   amount = 1 },
        },
        results = { 
            { type = "item", name = "rabbasca-obscure-theories", amount_min = 15, amount_max = 17 },
        },
        main_product = "rabbasca-obscure-theories",
        categories = { "rabbasca-relics" }
    },
    {
        type = "recipe",
        name = "rabbasca-restored-knowledge",
        enabled = false,
        energy_required = 8,
        ingredients = {
            { type = "item", name = "rabbasca-obscure-theories",  amount = 4, ignored_by_stats = 4 },
        },
        results = { 
            { type = "item", name = "rabbasca-sanity-loss", amount = 1, independent_probability = 0.005, always_fresh = true },
            { type = "item", name = "rabbasca-restored-knowledge", amount = 1, shared_probability = { min = 0, max = 0.1 } },
            { type = "item", name = "rabbasca-obscure-theories",  amount = 4, shared_probability = { min = 0.1, max = 1 }, ignored_by_productivity = 4, ignored_by_stats = 4 },
        },
        maximum_productivity = 249,
        main_product = "rabbasca-restored-knowledge",
        categories = { "crafting" }
    },
}