data:extend {
{
    type = "recipe-category",
    name = "rabbasca-psychosis"
},
{
    type = "recipe",
    name = "rabbasca-contained-imagination",
    subgroup = "rabbasca-security",
    order = "x[sanity-restore]",
    enabled = false,
    energy_required = 3,
    allow_productivity = true,
    auto_recycle = false,
    allow_intermediates = false,
    allow_as_intermediate = false,
    hide_from_player_crafting = false,
    ingredients = { { type = "item", name = "rabbasca-rampant-imagination", amount = 1, ignored_by_stats = 1 } },
    results = {
        { type = "item", name = "rabbasca-rampant-imagination", amount = 1, ignored_by_stats = 1, shared_probability = { min = 0, max = 0.9 } },
        { type = "item", name = "rabbasca-contained-imagination", amount = 1, always_fresh = true, shared_probability = { min = 0.9, max = 1 } },
    },
    main_product = "rabbasca-contained-imagination",
    categories = { "rabbasca-psychosis" }
},
{
    type = "recipe",
    name = "rabbasca-imaginary-science-pack",
    subgroup = "rabbasca-security",
    order = "x[sanity-restore]",
    enabled = false,
    energy_required = 12,
    allow_productivity = false,
    allow_quality = false,
    auto_recycle = false,
    hide_from_player_crafting = false,
    ingredients = { 
        { type = "item", name = "rabbasca-contained-imagination", amount = 1, ignored_by_stats = 1 },
    },
    results = {
        { type = "item", name = "rabbasca-imaginary-science-pack", amount = 1, shared_probability = { min = 0, max = 0.22 }, },
        { type = "item", name = "rabbasca-contained-imagination", amount = 1, shared_probability = { min = 0.22, max = 1 }, ignored_by_stats = 1, ignored_by_productivity = 1 },
    },
    main_product = "rabbasca-imaginary-science-pack",
    categories = { "rabbasca-psychosis" }
},
{
    type = "recipe",
    name = "rabbasca-imaginary-science-pack-duplication",
    icons = Rabbasca.icons { 
        { icon = "__rabbasca-assets__/graphics/recolor/icons/imaginary-science-pack.png", shift = { -4, -4 } },
        { icon = "__rabbasca-assets__/graphics/recolor/icons/imaginary-science-pack.png", shift = {  4,  4 } },
    },
    subgroup = "rabbasca-security",
    order = "x[sanity-restore]",
    enabled = false,
    energy_required = 17,
    allow_productivity = false,
    allow_quality = false,
    auto_recycle = false,
    hide_from_player_crafting = false,
    ingredients = { 
        { type = "item", name = "rabbasca-imaginary-science-pack", amount = 1, ignored_by_stats = 1 } 
    },
    results = {
        { type = "item", name = "rabbasca-imaginary-science-pack", amount_min = 1, amount_max = 6, ignored_by_stats = 1 },
    },
    categories = { "rabbasca-psychosis" }
},
{
    type = "recipe",
    name = "rabbasca-rampant-imagination-dummy",
    subgroup = "rabbasca-security",
    order = "x[sanity-restore]",
    enabled = false,
    energy_required = 0.5,
    allow_productivity = false,
    auto_recycle = false,
    hide_from_player_crafting = true,
    hidden = true,
    hidden_in_factoriopedia = true,
    allow_as_intermediate = false,
    ingredients = { },
    results = {
        { type = "item", name = "rabbasca-rampant-imagination", amount = 0 },
    },
    categories = { "parameters" }
},
}