data:extend {
{
    type = "string-setting",
    name = "rabbasca-underground-logistics-group-name",
    setting_type = "runtime-global",
    default_value = "[item=rabbasca-stabilize-warpfield] Warp-field stabilizer readings",
    allow_blank = false,
    hidden = true,
    order="u[ux]"
},
{
    type = "int-setting",
    name = "rabbasca-underground-starting-fuel",
    setting_type = "runtime-global",
    default_value = 42000,
    minimum_value = 10000,
    maximum_value = 100000,
    allow_blank = false,
    order="a[balance]"
},
{
    type = "bool-setting",
    name = "rabbasca-underground-can-pause-stabilizer",
    setting_type = "startup",
    default_value = true,
    allow_blank = false,
    order="a[balance]"
},
}