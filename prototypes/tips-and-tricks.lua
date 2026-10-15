data:extend {
{
    type = "tips-and-tricks-item",
    name = "rabbasca-underground-briefing",
    category = "space-age",
    tag = "[space-location=rabbasca-underground]",
    indent = 0,
    order = "r[rabbasca]-u",
    trigger = {
        type = "research",
        technology = "rabbasca-underground",
    },
    simulation = {
        planet = "rabbasca-underground",
        generate_map = false,
        checkboard = true,
        init_update_count = 300,
        init = [[
            require("__rabbasca-underground__.scripts.tips-simulations")
            simulation_briefing()
        ]],
    }
},
{
    type = "tips-and-tricks-item",
    name = "rabbasca-fuel-management",
    category = "space-age",
    tag = "[item=rabbasca-warp-cell]",
    indent = 1,
    order = "r[rabbasca]-u[aa-fuel]",
    trigger = {
        type = "research",
        technology = "rabbasca-stabilizer-on-aquilo",
    },
    simulation = {
        planet = "rabbasca-underground",
        generate_map = false,
        checkboard = true,
        init_update_count = 300,
        init = [[
            require("__rabbasca-underground__.scripts.tips-simulations")
            simulation_fuel_management()
        ]],
    }
},
{
    type = "tips-and-tricks-item",
    name = "rabbasca-manifest-anomaly",
    category = "space-age",
    tag = "[entity=rabbasca-warp-anomaly]",
    indent = 1,
    order = "r[rabbasca]-u[anomaly]",
    trigger = { type = "unlock-recipe", recipe = "rabbasca-stabilizer-warp-sequence" },
},
{
    type = "tips-and-tricks-item",
    name = "rabbasca-underground-automation",
    category = "space-age",
    tag = "[entity=constant-combinator]",
    indent = 1,
    order = "r[rabbasca]-u[automation]",
    trigger = { type = "research", technology = "rabbasca-archives" }
},
{
    type = "tips-and-tricks-item",
    name = "rabbasca-upgrade-placements",
    category = "space-age",
    tag = "[entity=rabbasca-collector-pylon][entity=rabbasca-stability-pylon]",
    indent = 1,
    order = "r[rabbasca]-u[upgrades]",
    trigger = { type = "unlock-recipe", recipe = "rabbasca-collector-pylon" },
    simulation = {
        planet = "rabbasca-underground",
        -- mods = { "rabbasca-underground" },
        generate_map = false,
        checkboard = true,
        game_view_settings = { default_show_value = false, show_controller_gui = true, update_entity_selection = true },
        init_update_count = 300,
        init = [[
            require("__rabbasca-underground__.scripts.tips-simulations")
            simulation_relocation()
        ]],
    }
}
}