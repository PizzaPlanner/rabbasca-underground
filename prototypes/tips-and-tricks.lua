data:extend {
{
    type = "tips-and-tricks-item",
    name = "rabbasca-underground-briefing",
    category = "space-age",
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
    category = "space-age",
    tag = "[entity=rabbasca-warp-anomaly]",
    indent = 1,
    order = "r[rabbasca]-u[anomaly]",
    trigger = {
        type = "research",
        technology = "rabbasca-underground",
    },
}
}