local item_sounds = require("__base__.prototypes.item_sounds")

local make_tile_area = function(area, name)
  local result = {}
  local left_top = area[1]
  local right_bottom = area[2]
  for x = left_top[1], right_bottom[1] do
    for y = left_top[2], right_bottom[2] do
      table.insert(result,
      {
        position = {x, y},
        tile = name
      })
    end
  end
  return result
end

data:extend{
{
  type = "fuel-category",
  name = "rabbasca-warp-anomaly",
},
Rabbasca.make_trigger_item({
  name = "rabbasca-locate-stabilizer",
  subgroup = "rabbasca-warp-stabilizer",
  order = "z[locate-underground]",
  icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
  icon_size = 640,
}, "rabbasca_on_send_pylon_underground"),
Rabbasca.make_trigger_item({
  name = "rabbasca-reboot-stabilizer",
  subgroup = "rabbasca-warp-stabilizer",
  order = "z[locate-underground-reboot]",
  icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
  icon_size = 640,
}, "rabbasca_on_reboot_underground"),
Rabbasca.make_trigger_item({
  name = "rabbasca-stabilize-warpfield",
  subgroup = "rabbasca-warp-stabilizer",
  order = "z[stabilize]",
  icons = Rabbasca.icons({ proto = data.raw["virtual-signal"]["signal-recycle"], tint = { 0.83, 1, 0.15} })
}, "rabbasca_warp_progress"),
Rabbasca.make_trigger_item({
  name = "rabbasca-stabilizer-warp-sequence",
  subgroup = "rabbasca-warp-stabilizer",
  order = "z[stabilize]-b",
  icons = Rabbasca.icons({ proto = data.raw["virtual-signal"]["rabbasca-warp-inventory"], tint = { 0.83, 1, 0.15} })
}, "rabbasca_warp_progress_warp"),
Rabbasca.make_trigger_item({
  name = "rabbasca-destabilize-warpfield",
  subgroup = "rabbasca-warp-stabilizer",
  order = "z[destabilize]",
  icons = Rabbasca.icons({
    { proto = data.raw["virtual-signal"]["signal-recycle"], tint = { 0.83, 1, 0.15} }
  })
}, "rabbasca_warp_unprogress"),
{
  type = "item",
  name = "rabbasca-lithium-amide",
  icon = "__rabbasca-assets__/graphics/recolor/icons/lithium-amide.png",
  icon_size = 128,
  stack_size = 50,
  weight = 25 * kg,
  auto_recycle = false,
  subgroup = "rabbasca-processes",
  order = "u[underground]-a[amide]"
},
{
  type = "item",
  name = "rabbasca-warp-cell",
  icons = Rabbasca.icons({{ proto = data.raw["item"]["fusion-power-cell"], tint = {0.8, 0.8, 1} }}),
  -- fuel_value = "10GJ",
  -- fuel_category = "rabbasca-warp-anomaly",
  spoil_ticks = 5 * minute,
  spoil_result = "rabbasca-warp-matrix",
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[warp-matrix]-b[warp-cell]",
  stack_size = 1,
},
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    name = "rabbasca-warp-matrix",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
    stack_size = 1000,
    fuel_value = "500MJ",
    fuel_category = "rabbasca-warp-anomaly",
    weight = 1 * kg,
    localised_description = { "item-description.rabbasca-warp-matrix" },
    spoil_ticks = 20 * second,
    auto_recycle = false,
    subgroup = "rabbasca-warp-stabilizer",
    order = "a[warp-matrix]",
  },
},
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    name = "rabbasca-quantum-device",
    icon = "__rabbasca-assets__/graphics/by-openai/quantum-foam-encapsulator.png",
    icon_size = 432,
    stack_size = 100,
    weight = 50 * kg,
    subgroup = "rabbasca-warp-stabilizer",
    order = "b[science]-b",
  },
},
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    name = "rabbasca-coordinate-system",
    icon = "__rabbasca-assets__/graphics/by-openai/coordinate-system.png",
    icon_size = 432,
    stack_size = 200,
    weight = 1 * kg,
    auto_recycle = false,
    subgroup = "rabbasca-warp-stabilizer",
    order = "b[science]-c",
  },
},
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    name = "rabbasca-spacetime-sensor",
    icon = "__rabbasca-assets__/graphics/by-openai/spacetime-fluctuation-sensor.png",
    icon_size = 432,
    stack_size = 200,
    weight = 1 * kg,
    auto_recycle = false,
    subgroup = "rabbasca-warp-stabilizer",
    order = "b[science]-d",
  },
},
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    name = "rabbasca-spatial-anchor",
    icon = "__rabbasca-assets__/graphics/by-openai/spatial-anchor.png",
    icon_size = 432,
    stack_size = 50,
    weight = 10 * kg,
    auto_recycle = false,
    subgroup = "rabbasca-warp-stabilizer",
    order = "b[science]-e",
  },
},
{
  type = "item",
  name = "rabbasca-warp-tech-analyzer",
  icon = data.raw["item"]["lab"].icon,
  place_result = "rabbasca-warp-tech-analyzer",
  stack_size = 10,
  weight = 100 * kg,
  subgroup = data.raw["item"]["lab"].subgroup,
  order = data.raw["item"]["lab"].order.."-r[rabbasca-underground]",
},
{
  type = "item",
  name = "rabbasca-collector-pylon",
  icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-2.png",
  icon_size = 64,
  place_result = "rabbasca-collector-pylon",
  stack_size = 10,
  weight = 100 * kg,
  subgroup = data.raw["item"]["rabbasca-warp-pylon"].subgroup,
  order = data.raw["item"]["rabbasca-warp-pylon"].order.."-r[rabbasca-underground]",
},
{
  type = "item",
  name = "rabbasca-warp-uplink-2",
  icons = { { icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon.png", icon_size = 64, tint = { 0.7, 0.5, 1 } } },
  stack_size = 10,
  place_result = "rabbasca-warp-uplink-2",
  weight = 100 * kg,
  subgroup = "rabbasca-remote-warping",
  order = "a[placeable]-b[input-2]",
},
-- {
--     type = "ammo",
--     name = "self-replicating-firearm-magazine",
--     category = data.raw["ammo"]["firearm-magazine"].category,
--     icons = {
--       { icon = "__base__/graphics/icons/firearm-magazine.png", tint = { r = 0.95, g = 1, b = 1 }, shift = { -8, -8 } },
--       { icon = "__base__/graphics/icons/firearm-magazine.png", tint = { r = 0.95, g = 1, b = 1 }, shift = { 0,   0 } },
--       { icon = "__base__/graphics/icons/firearm-magazine.png", tint = { r = 0.95, g = 1, b = 1 }, shift = { 8,   8 } } 
--     },
--     stack_size = 20,
--     weight = 25 * kg,
--     ammo_type = table.deepcopy(data.raw["ammo"]["firearm-magazine"].ammo_type),
--     ammo_category = "bullet",
--     magazine_size = 500,
--     spoil_ticks = 10 * second,
--     spoil_result = "self-replicating-firearm-magazine"
-- },
}