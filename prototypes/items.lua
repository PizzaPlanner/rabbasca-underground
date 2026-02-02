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
}, "rabbasca_on_send_pylon_underground"),
Rabbasca.make_trigger_item({
  name = "rabbasca-stabilize-warpfield",
  subgroup = "rabbasca-warp-stabilizer",
  order = "z[stabilize]",
  icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
  icon_size = 640,
}, "rabbasca_warp_progress"),
{
  type = "item",
  name = "rabbasca-lithium-amide",
  icon = data.raw["item"]["lithium"].icon,
  stack_size = 50,
  weight = 25 * kg,
  auto_recycle = false,
  subgroup = "rabbasca-processes",
  order = "u[underground]-a[amide]"
},
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    name = "rabbasca-warp-matrix",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
    stack_size = 1000,
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
  type = "space-platform-starter-pack",
  name = "rabbasca-space-platform-starter-pack",
  icons = Rabbasca.icons({
    { proto = data.raw["space-platform-starter-pack"]["space-platform-starter-pack"], scale = 1 },
    { proto = data.raw["fluid"]["harene"], scale = 0.3, shift = { 8, 8 } },
  }),
  inventory_move_sound = item_sounds.mechanical_large_inventory_move,
  pick_sound = item_sounds.mechanical_large_inventory_pickup,
  drop_sound = item_sounds.mechanical_large_inventory_move,
  stack_size = 1,
  weight = 1*tons,
  trigger =
  {
    {
      type = "direct",
      action_delivery =
      {
        type = "instant",
        source_effects =
        {
          {
            type = "create-entity",
            entity_name = "space-platform-hub"
          },
          {
            type = "create-entity",
            entity_name = "rabbasca-platform-energy-source"
          },
        }
      }
    }
  },
  surface = "rabbasca-space-platform",
  create_electric_network = true,
  tiles = make_tile_area({{-5, -5}, {4, 4}}, "space-platform-foundation"),
  subgroup = "space-rocket",
  order = "b[space-platform-starter-pack]-r[rabbasca]",
  initial_items = {
    { type = "item", name = "haronite-plate", amount = 20 }
  }
}
}