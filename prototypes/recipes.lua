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
        type = "recipe",
        name = "rabbasca-lithium-amide-fission",
        icons = {
            { icon = data.raw["item"]["rabbasca-lithium-amide"].icon, scale = 0.5, shift = {-3, -8}, icon_size = 64 },
            { icon = data.raw["item"]["lithium"].icon, scale = 0.5, shift = {8, 3}, icon_size = 64 },
            { icon = data.raw["fluid"]["ammonia"].icon, scale = 0.5, shift = {3, 8}, icon_size = 64 },
        },
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
        name = "rabbasca-reboot-stabilizer",
        enabled = true,
        hidden = true,
        hidden_in_factoriopedia = true,
        main_product = "rabbasca-reboot-stabilizer",
        energy_required = 0.1,
        ingredients = { },
        results = { { type = "item", name = "rabbasca-reboot-stabilizer", amount = 1 }, { type = "item", name = "ice", amount = 50 } },
        category = "rabbasca-warp-stabilizer",
        result_is_always_fresh = true,
        auto_recycle = false,
        crafting_machine_tint = {
            primary = { 0.95, 0.83, 0.14 }
        }
    },
    {
        type = "recipe",
        name = "rabbasca-stabilize-warpfield",
        -- icons = Rabbasca.icons({proto = data.raw["tool"]["rabbasca-warp-matrix"]}),
        enabled = false,
        energy_required = 2,
        result_is_always_fresh = true,
        -- preserve_products_in_machine_output = true,
        ingredients = { },
        allow_productivity = false,
        results = { { type = "item", name = "rabbasca-stabilize-warpfield", amount = 1 } },
        crafting_machine_tint =
        {
            primary = { 0.5, 0.83, 1 }
        },
        category = "rabbasca-warp-stabilizer"
    },
    {
        type = "recipe",
        name = "rabbasca-amplify-anomaly",
        icons = Rabbasca.icons({proto = data.raw["tool"]["rabbasca-warp-matrix"]}),
        enabled = false,
        energy_required = 3600,
        result_is_always_fresh = true,
        -- preserve_products_in_machine_output = true,
        ingredients = { { type = "item", name = "rabbasca-warp-matrix", amount = 1 } },
        allow_productivity = false,
        overload_multiplier = 999,
        results = { },
        crafting_machine_tint =
        {
            primary = { 0.81, 0.27, 1 }
        },
        category = "rabbasca-remote"
    },
    {
        type = "recipe",
        name = "rabbasca-coordinate-system",
        enabled = false,
        energy_required = 5,
        ingredients = {
            { type = "item",  name = "rabbasca-warp-matrix", amount = 5 },
            { type = "item", name = "low-density-structure",  amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-coordinate-system", amount = 1 } },
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
        },
        results = { { type = "item", name = "rabbasca-spatial-anchor", amount = 1 } },
        category = "electromagnetics",
        surface_conditions = { Rabbasca.only_underground(true) },
    },
    {
        type = "recipe",
        name = "rabbasca-quantum-device",
        enabled = false,
        energy_required = 7,
        ingredients = {
            { type = "item", name = "tungsten-ore", amount = 5 },
            { type = "fluid", name = "holmium-solution", amount = 70 },
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
        name = "rabbasca-space-platform-starter-pack",
        enabled = false,
        energy_required = 40,
        ingredients = {
            { type = "item", name = "space-platform-starter-pack", amount = 1 },
            { type = "item", name = "haronite-plate",  amount = 20 },
            { type = "fluid", name = "harene",  amount = 5000 },
        },
        results = { { type = "item", name = "rabbasca-space-platform-starter-pack", amount = 1 } },
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
      { type = "item", name = "haronite-plate", amount = 5 },
      { type = "item", name = "rabbasca-warp-pylon", amount = 1 },
      { type = "item", name = "rabbasca-energetic-concrete", amount = 4 },
      { type = "item", name = "fusion-power-cell", amount = 10 },
  },
  results = { 
      { type = "item", name = "rabbasca-locate-stabilizer", amount = 1 },
  },
  energy_required = 120,
  allow_productivity = false,
})