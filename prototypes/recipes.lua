data:extend {
    {
        type = "recipe-category",
        name = "rabbasca-warp-stabilizer",
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
        name = "rabbasca-warp-cell",
        enabled = false,
        energy_required = 8,
        result_is_always_fresh = true,
        ingredients = { 
            { type = "item", name = "rabbasca-warp-trace", amount = 50 }, 
            { type = "item", name = "rabbasca-warp-cell-recharging", amount = 1 } },
        results = { 
            { type = "item", name = "rabbasca-warp-cell", amount = 1 } },
        allow_productivity = false,
        auto_recycle = false,
        crafting_machine_tint =
        {
            primary = { 0.85, 0.42, 1 }
        },
        stabilizer_config = { can_craft_for_free = true, freecraft_time_multiplier = 2 },
        category = "rabbasca-remote",
        order = "b",
        additional_categories = { "rabbasca-warp-stabilizer" }
    },
    {
        type = "recipe",
        name = "rabbasca-warp-cell-recharging",
        enabled = false,
        energy_required = 8,
        result_is_always_fresh = true,
        ingredients = { 
            { type = "item", name = "rabbasca-warp-cell-empty", amount = 1 }, 
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 8 } },
        results = { 
            { type = "item", name = "rabbasca-warp-cell-recharging", amount = 1 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.95 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.95 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.95 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.95 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.95 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.95 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.95 },
            { type = "item", name = "rabbasca-warpfield-excitement-rod", amount = 1, probability = 0.95 },
        },
        main_product = "rabbasca-warp-cell-recharging",
        allow_productivity = false,
        auto_recycle = false,
        crafting_machine_tint =
        {
            primary = { 0.85, 0.42, 1 }
        },
        stabilizer_config = { can_craft_for_free = true, freecraft_time_multiplier = 2 },
        category = "rabbasca-remote",
        order = "b",
        additional_categories = { "rabbasca-warp-stabilizer" }
    },
    {
        type = "recipe",
        name = "rabbasca-warpfield-excitement-rod",
        enabled = false,
        energy_required = 8,
        result_is_always_fresh = true,
        ingredients = { 
            { type = "item", name = "rabbasca-warp-matrix", amount = 50 },
            { type = "item", name = "lithium-amide", amount = 50 },
            { type = "fluid", name = "fluorine", amount = 200 } },
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
        name = "rabbasca-abandon-stabilizer",
        enabled = false,
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
        name = "rabbasca-stabilizer-toggle-extractor",
        enabled = false,
        hidden_in_factoriopedia = true,
        energy_required = 30,
        result_is_always_fresh = true,
        -- ingredients = { { type = "item", name = "rabbasca-warp-cell", amount = 5 } },
        results = { { type = "item", name = "rabbasca-stabilizer-toggle-extractor", amount = 1 } },
        allow_productivity = false,
        stabilizer_config = { }, -- cache energy_required
        crafting_machine_tint =
        {
            primary = { 0.25, 0.85, 0.05 }
        },
        category = "rabbasca-warp-stabilizer",
        order = "c",
        hide_from_signal_gui = false
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
        name = "rabbasca-stabilize-warpfield",
        enabled = false,
        hidden_in_factoriopedia = true,
        energy_required = 2,
        result_is_always_fresh = true,
        ingredients = { { type = "item", name = "rabbasca-warp-matrix", amount = 50 } },
        results = { 
            { type = "item", name = "rabbasca-warp-trace", amount = 10 }
        },
        -- main_product = "rabbasca-stabilize-warpfield",
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
            { type = "item",  name = "rabbasca-warp-matrix", amount = 10 },
            { type = "item", name = "haronite-plate",  amount = 1 },
            { type = "fluid", name = "fluorine",  amount = 200 },
        },
        results = { { type = "item", name = "rabbasca-coordinate-system", amount = 3 } },
        surface_conditions = { Rabbasca.only_underground(true) },
        category = "cryogenics"
    },
    {
        type = "recipe",
        name = "rabbasca-spatial-anchor",
        enabled = false,
        energy_required = 5,
        ingredients = {
            { type = "fluid",  name = "holmium-solution", amount = 20 },
            { type = "item",  name = "low-density-structure",  amount = 5 },
            { type = "item",  name = "stone-brick",  amount = 20 },
        },
        results = { { type = "item", name = "rabbasca-spatial-anchor", amount = 1 } },
        category = "complex-machinery",
        surface_conditions = { Rabbasca.only_underground(true) },
    },
    {
        type = "recipe",
        name = "rabbasca-quantum-device",
        enabled = false,
        energy_required = 7,
        ingredients = {
            { type = "item", name = "rabbasca-warp-matrix", amount = 10 },
            { type = "item", name = "tungsten-plate", amount = 5 },
            { type = "item", name = "fusion-power-cell", amount = 1 },
            { type = "fluid", name = "harenic-lava", amount = 300 },
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
            { type = "fluid", name = "harene", amount = 5 },
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
        enabled = false,
        auto_recycle = false,
        energy_required = 25,
        ingredients = {
            { type = "item", name = "rabbasca-quantum-device", amount = 1 },
            { type = "item", name = "rabbasca-coordinate-system", amount = 1 },
            { type = "item", name = "rabbasca-spatial-anchor",  amount = 1 },
            { type = "item", name = "rabbasca-spacetime-sensor",  amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-warp-core", amount = 1 } },
        category = "electromagnetics"
    },
    {
        type = "recipe",
        name = "rabbasca-warp-tech-analyzer",
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item", name = "lab", amount = 1 },
            { type = "item", name = "pipe",  amount = 10 },
        },
        results = { { type = "item", name = "rabbasca-warp-tech-analyzer", amount = 1 } },
        category = "crafting"
    },
    {
        type = "recipe",
        name = "rabbasca-collector-pylon",
        enabled = false,
        energy_required = 2,
        ingredients = {
            { type = "item", name = "rabbasca-warp-core", amount = 2 },
            { type = "item", name = "haronite-plate",  amount = 5 },
            { type = "item", name = "processing-unit",  amount = 10 },
            { type = "item", name = "rabbasca-spacetime-sensor",  amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-collector-pylon", amount = 1 } },
        category = "complex-machinery"
    },
    {
        type = "recipe",
        name = "rabbasca-warp-uplink-2",
        enabled = false,
        energy_required = 5,
        ingredients = {
            { type = "item", name = "rabbasca-warp-uplink", amount = 1 },
            { type = "item", name = "rabbasca-warp-core",   amount = 5 },
            { type = "item", name = "rabbasca-lithium-amide",   amount = 20 },
        },
        results = { { type = "item", name = "rabbasca-warp-uplink-2", amount = 1 } },
        category = "complex-machinery"
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