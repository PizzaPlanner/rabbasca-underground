data:extend {
{
    type = "string-setting",
    name = "rabbasca-underground-logistics-group-name",
    setting_type = "runtime-global",
    default_value = "[item=rabbasca-warp-trace] Warpfield stabilizer readings",
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
    name = "rabbasca-expand-imaginary-science-usage",
    setting_type = "startup",
    default_value = false,
    allow_blank = false,
    order="a[balance]"
},
{
    type = "bool-setting",
    name = "rabbasca-insanity-where-looking",
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
{
    type = "bool-setting",
    name = "rabbasca-knowledge-efficiency-ignores-multiplier",
    setting_type = "startup",
    default_value = true,
    allow_blank = false,
    order="a[balance]"
},
{
    type = "bool-setting",
    name = "rabbasca-underground-lut-simple",
    setting_type = "startup",
    default_value = false,
    allow_blank = false,
    order="u[ux]"
},
{
    type = "bool-setting",
    name = "rabbasca-underground-full-spaghetti-mode",
    setting_type = "startup",
    default_value = false,
    allow_blank = false,
    order="a[balance]"
},
}

if mods["lignumis"] then
    data:extend {
        {
            type = "bool-setting",
            name = "rabbasca-ug-target-lignumis",
            setting_type = "startup",
            default_value = true,
            allow_blank = false,
            localised_name = { "mod-setting-name.rabbasca-ug-target", "lignumis" },
            localised_description = { "", { "mod-setting-description.rabbasca-ug-target", "lignumis", }, "\n", "[item=wood]", "\n", "[item=peat]" },
            order="a[balance]"
        }
    }
end