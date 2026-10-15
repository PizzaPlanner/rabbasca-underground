data:extend { 
{
  type = "achievement",
  name = "rabbasca-stabilizer-oopsie",
  order = "r[rabbasca]-ug[oopsie]",
  icon = "__base__/graphics/achievement/destroyer-of-worlds.png",
  icon_size = 128
},
{
  type = "achievement",
  name = "rabbasca-out-of-bounds",
  order = "r[rabbasca]-ug[zz-out-of-bounds]",
icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/recolor/textures/achievement-oob.png", icon_size = 128 },
    { icon = "__base__/graphics/icons/signal/signal-no-entry.png", scale = 0.5 },
    { proto = data.raw["planet"]["rabbasca-underground"], scale = 0.5, shift = { 10, 10 }, floating = true }
  }, 128)
},
{
  type = "achievement",
  name = "rabbasca-employee-of-the-month",
  order = "r[rabbasca]-ug[employee]",
  icons = Rabbasca.icons({
      { icon = "__rabbasca-assets__/graphics/recolor/textures/achievement-bg-upper.png", icon_size = 128 },
      { proto = data.raw["item"]["rabbasca-powerspike"], scale = 0.7 },
      { icon = "__rabbasca-assets__/graphics/recolor/textures/achievement-bg-lower.png", icon_size = 128 },
  }, 128)
},
{
  type = "research-achievement",
  name = "rabbasca-just-why",
  technology = "rabbasca-inhibit-imagination",
  order = "r[rabbasca]-ug[just-why]",
  icon = "__rabbasca-assets__/graphics/recolor/textures/achievement-why.png",
  icon_size = 128
},
{
  type = "achievement",
  name = "rabbasca-full-spaghetti",
  order = "r[rabbasca]-ug[pasta-day]",
  icon = "__rabbasca-assets__/graphics/recolor/textures/achievement-spaghetti.png",
  icon_size = 128
}
}