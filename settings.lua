data:extend {
{
    type = "string-setting",
    name = "rabbasca-underground-logistics-group-name",
    setting_type = "runtime-global",
    default_value = "[item=rabbasca-warp-trace] Warp-field stabilizer readings",
    allow_blank = false,
    hidden = true,
    order="u[ux]"
},
{
    type = "bool-setting",
    name = "rabbasca-expand-warpfield-science-usage",
    setting_type = "startup",
    default_value = true,
    allow_blank = false,
    order="a[balance]"
},
{
    type = "bool-setting",
    name = "rabbasca-interplanetary-construction-3-requires-warpfield-science",
    setting_type = "startup",
    default_value = false,
    allow_blank = false,
    order="a[balance]"
},
}