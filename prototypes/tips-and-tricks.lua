data:extend {
{
    type = "tips-and-tricks-item",
    name = "rabbasca-underground-briefing",
    categories = { "space-age" },
    tag = "[space-location=rabbasca-underground]",
    indent = 1,
    order = "r[rabbasca]-u",
    trigger = {
        type = "research",
        technology = "rabbasca-underground",
    },
},
{
    type = "tips-and-tricks-item",
    name = "rabbasca-manifest-anomaly",
    categories = { "space-age" },
    tag = "[entity=rabbasca-warp-anomaly]",
    indent = 1,
    order = "r[rabbasca]-u[anomaly]",
    trigger = { type = "craft-item", item = "rabbasca-stabilizer-warp-sequence", event_type = "crafting-finished", count = 3 },
},
{
    type = "tips-and-tricks-item",
    name = "rabbasca-upgrade-placements",
    categories = { "space-age" },
    tag = "[entity=rabbasca-collector-pylon][entity=rabbasca-stability-pylon]",
    indent = 1,
    order = "r[rabbasca]-u[upgrades]",
    trigger = {
        type = "or",
        triggers = {
            { type = "craft-item", item = "rabbasca-collector-pylon", event_type = "crafting-finished", count = 1 },
            { type = "craft-item", item = "rabbasca-stability-pylon", event_type = "crafting-finished", count = 1 },
        }
    },
}
}