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
    trigger = { type = "unlock-recipe", recipe = "rabbasca-collector-pylon" }
}
}