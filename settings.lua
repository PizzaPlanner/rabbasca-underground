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
    order="a[balance]"
},
}