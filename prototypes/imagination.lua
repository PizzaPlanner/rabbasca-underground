data:extend {
{
    type = "recipe-category",
    name = "rabbasca-imagination"
},
{
    type = "fuel-category",
    name = "rabbasca-imagination"
},
{
    type = "recipe",
    name = "rabbasca-sanity-mote-unlock",
    icon = "__rabbasca-assets__/graphics/recolor/icons/sanity-mote.png",
    icon_size = 76,
    subgroup = "rabbasca-security",
    order = "x[sanity-restore]",
    enabled = false,
    energy_required = 1,
    allow_productivity = false,
    auto_recycle = false,
    hide_from_player_crafting = true,
    hidden = true,
    hidden_in_factoriopedia = true,
    ingredients = { { type = "item", name = "rabbasca-psychosis", amount = 1 } },
    results = {
        { type = "item", name = "rabbasca-sanity-mote", amount = 1 },
    },
    categories = { "hand-crafting" }
},
{
    type = "recipe",
    name = "rabbasca-imaginary-creation-autocraft",
    icon = "__rabbasca-assets__/graphics/recolor/icons/sanity-mote.png",
    icon_size = 76,
    subgroup = "rabbasca-security",
    order = "x[sanity-restore]",
    enabled = true,
    energy_required = 1,
    allow_productivity = true,
    auto_recycle = false,
    hide_from_player_crafting = false,
    hidden = false,
    hidden_in_factoriopedia = false,
    ingredients = { { type = "item", name = "rabbasca-sanity-mote", amount = 1 } },
    results = {
        { type = "item", name = "rabbasca-imaginary-science-pack-precursor", amount = 1, always_fresh = true, shared_probability = { min = 0, max = 0.1 } },
        { type = "item", name = "rabbasca-psychosis", amount = 1, always_fresh = true, shared_probability = { min = 0.1, max = 1 } },
    },
    categories = { "hand-crafting" }
},
-- {
--     type = "recipe",
--     name = "rabbasca-embrace-insanity",
--     icon = "__rabbasca-assets__/graphics/recolor/icons/sanity-mote.png",
--     icon_size = 76,
--     subgroup = "rabbasca-security",
--     order = "x[sanity-restore]",
--     enabled = false,
--     energy_required = 5,
--     allow_productivity = true,
--     auto_recycle = false,
--     ingredients = { 
--         { type = "item", name = "rabbasca-imaginary-science-pack-precursor", amount = 1 },
--         { type = "item", name = "beta-carotene-barrel", amount = 10 },
--     },
--     results = { 
--         { type = "item", name = "rabbasca-psychosis", amount = 1, always_fresh = true },
--         { type = "item", name = "rabbasca-psychic-magazine", amount = 5, always_fresh = true, independent_probability = 0.21 },
--         { type = "item", name = "construction-robot", amount = 3, always_fresh = true, independent_probability = 0.14 },
--     },
--   categories = { "hand-crafting" }
-- },
{
    type = "lab",
    name = "rabbasca-imagination-altar",
    crafting_speed = 0.25,
    collision_box = { { -1.3, -1.3 }, { 1.3, 1.3 } },
    selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
    energy_usage = "100kW",
    energy_source = {
        type                 = "burner",
        fuel_inventory_size  = 2,
        burnt_inventory_size = 2,
        fuel_categories      = { "rabbasca-imagination" },
    },
    module_slots = 4,
    subgroup = "rabbasca-warp-stabilizer",
    order = "a[stabilizer]",
    allowed_effects = { "speed", "productivity", "quality"},
    minable = {mining_time = 0.5, result = "rabbasca-imagination-altar"},
    placeable_by = { item = "rabbasca-imagination-altar", count = 1 },
    max_health = 250,
    resistances = { { type = "rabbasca-psychic", percent = 100 } },
    inputs = { }, -- in final-fixes
    off_animation = {
        filename = "__rabbasca-assets__/graphics/recolor/entities/sanity-altar.png",
        frame_count = 1,
        line_length = 1,
        width = 268,
        height = 258,
        scale = 0.5,
        flags = {"no-scale"},
        shift = {0, 0},
    },
}
}