data:extend {
{
    type = "item-subgroup",
    name = "rabbasca-imagination",
    group = "intermediate-products",
    order = "yz[sanity]"
},
{
    type = "recipe-category",
    name = "rabbasca-psychosis"
},
{
    type = "recipe-category",
    name = "rabbasca-psychosis-manual"
},
{
    type = "recipe",
    name = "rabbasca-psychosis",
    subgroup = "rabbasca-imagination",
    order = "a[psychosis]",
    enabled = false,
    energy_required = 0.75,
    allow_productivity = true,
    auto_recycle = false,
    allow_intermediates = false,
    allow_as_intermediate = false,
    hide_from_player_crafting = false,
    ingredients = { },
    results = {
        { type = "item", name = "rabbasca-psychosis", amount = 0 },
        { type = "item", name = "rabbasca-rampant-imagination", amount = 1, shared_probability = { min = 0, max = 0.0666 } },
    },
    main_product = "rabbasca-psychosis",
    categories = { "rabbasca-psychosis-manual" }
},
{
    type = "recipe",
    name = "rabbasca-rampant-imagination",
    icons = generate_recycling_recipe_icons_from_item({ 
        icon = "__rabbasca-assets__/graphics/recolor/icons/imaginary-science-pack-precursor.png",
        icon_size = 64, 
    }),
    subgroup = "rabbasca-imagination",
    order = "b[rampant]",
    enabled = false,
    energy_required = 6,
    allow_quality = false,
    allow_productivity = true,
    auto_recycle = false,
    allow_intermediates = false,
    allow_as_intermediate = false,
    hide_from_player_crafting = false,
    ingredients = { 
        { type = "item", name = "rabbasca-contained-imagination", amount = 1 },
    },
    results = {
        { type = "item", name = "rabbasca-rampant-imagination", amount = 5, quality_change = -1, percent_spoiled = 0.5, always_fresh = true, ignored_by_productivity = 5 },
    },
    -- main_product = "rabbasca-rampant-imagination",
    categories = { "rabbasca-psychosis-manual", "recycling" }
},
{
    type = "recipe",
    name = "rabbasca-contained-imagination",
    subgroup = "rabbasca-imagination",
    order = "c[contained]",
    enabled = false,
    energy_required = 2,
    allow_quality = false,
    allow_productivity = true,
    auto_recycle = false,
    allow_intermediates = false,
    allow_as_intermediate = false,
    hide_from_player_crafting = false,
    ingredients = { 
        { type = "item", name = "rabbasca-rampant-imagination", amount = 5, ignored_by_stats = 5 },
        -- { type = "item", name = "plastic-bottle", amount = 1, ignored_by_stats = 1 },
    },
    results = {
        { type = "item", name = "rabbasca-rampant-imagination", amount = 5, ignored_by_stats = 5, shared_probability = { min = 0.173, max = 1 }, ignored_by_productivity = 5 },
        { type = "item", name = "rabbasca-contained-imagination", amount = 1, shared_probability = { min = 0, max = 0.173 }, ignored_by_productivity = 1 },
    },
    main_product = "rabbasca-contained-imagination",
    categories = { "rabbasca-psychosis" }
},
{
    type = "recipe",
    name = "rabbasca-contained-imagination-refresh",
    icon = "__rabbasca-assets__/graphics/recolor/icons/imaginary-science-pack-precursor-reprocessing.png",
    icon_size = 64,
    subgroup = "rabbasca-imagination",
    order = "d[contained-restore]",
    enabled = false,
    energy_required = 15,
    allow_quality = false,
    allow_productivity = true,
    auto_recycle = false,
    allow_intermediates = false,
    allow_as_intermediate = false,
    hide_from_player_crafting = false,
    ingredients = { 
        { type = "item", name = "rabbasca-contained-imagination", amount = 90, ignored_by_stats = 90 },
        { type = "item", name = "rabbasca-rampant-imagination", amount = 50 },
    },
    results = {
        { type = "item", name = "rabbasca-contained-imagination", amount = 100, ignored_by_stats = 90, ignored_by_productivity = 100 },
    },
    raise_on_crafted = true,
    categories = { "rabbasca-psychosis" }
},
{
    type = "recipe",
    name = "rabbasca-imaginary-science-pack",
    subgroup = "science-pack",
    order = "k-r[rabbasca-imagine]",
    enabled = false,
    energy_required = 12,
    allow_productivity = false,
    allow_quality = false,
    auto_recycle = false,
    hide_from_player_crafting = false,
    ingredients = { 
        { type = "item", name = "rabbasca-contained-imagination", amount = 3, ignored_by_stats = 3 },
    },
    results = {
        { type = "item", name = "rabbasca-imaginary-science-pack", amount = 1, independent_probability = 0.333, },
        { type = "item", name = "rabbasca-contained-imagination", amount = 1, independent_probability = 0.99, ignored_by_stats = 1, ignored_by_productivity = 1 },
        { type = "item", name = "rabbasca-contained-imagination", amount = 1, independent_probability = 0.99, ignored_by_stats = 1, ignored_by_productivity = 1 },
        { type = "item", name = "rabbasca-contained-imagination", amount = 1, independent_probability = 0.99, ignored_by_stats = 1, ignored_by_productivity = 1 },
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
    subgroup = "rabbasca-imagination",
    order = "e[science-pack]",
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
}