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
{
  type = "module-category",
  name = "rabbasca-stabilizer-module",
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
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "z[locate-underground-reboot]",
  icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png",
  icon_size = 640,
}, "rabbasca_on_reboot_underground"),
Rabbasca.make_trigger_item({
  name = "rabbasca-stabilizer-warp-sequence",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "a",
  icons = Rabbasca.icons({ proto = data.raw["virtual-signal"]["rabbasca-warp-inventory"], tint = { 0.83, 1, 0.15} })
}, "rabbasca_warp_progress_warp"),
Rabbasca.make_trigger_item({
  name = "rabbasca-destabilize-warpfield",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "z[destabilize]",
  icons = Rabbasca.icons({
    { proto = data.raw["virtual-signal"]["signal-recycle"], tint = { 0.83, 1, 0.15} }
  })
}, "rabbasca_warp_unprogress"),
Rabbasca.make_trigger_item({
  name = "rabbasca-stabilizer-toggle-component",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "e",
  icons = Rabbasca.icons({
    { proto = data.raw["item"]["engine-unit"] }
  })
}, "rabbasca_on_toggle_component"),
Rabbasca.make_trigger_item({
  name = "rabbasca-abandon-stabilizer",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "zz",
  icons = Rabbasca.icons({
    { proto = data.raw["virtual-signal"]["signal-explosion"] }
  })
}, "rabbasca_on_abandon"),
Rabbasca.make_trigger_item({
  name = "rabbasca-summon-ufo",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "zz",
  hidden = false,
  icons = Rabbasca.icons({
    { proto = data.raw["spider-vehicle"]["rabbasca-ufo"] },
    { proto = data.raw["virtual-signal"]["rabbasca-warp-inventory"], scale = 0.3, shift = {8,8} },
  })
}, "rabbasca_on_summon_ufo"),
Rabbasca.make_trigger_item({
  name = "rabbasca-stabilizer-repair-component",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "zz",
  icons = Rabbasca.icons({
    { proto = data.raw["virtual-signal"]["signal-radioactivity"] }
  })
}, "rabbasca_on_repair_component"),
Rabbasca.make_trigger_item({
  name = "rabbasca-floor-stability-upkeep",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "zz",
  icons = Rabbasca.icons({
    { proto = data.raw["virtual-signal"]["signal-radioactivity"] }
  })
}, "rabbasca_on_floor_stability"),
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    name = "rabbasca-twisted-knowledge",
    icons = Rabbasca.icons({
      { proto = data.raw["blueprint-book"]["blueprint-book"] }
    }),
    auto_recycle = false,
    stack_size = 200,
  },
},
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    -- type = "item",
    name = "rabbasca-warp-trace",
    subgroup = "rabbasca-warp-stabilizer",
    order = "a[warp-anomaly]-x[residue]",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-trace.png",
    icon_size = 256,
    localised_description = { "item-description.rabbasca-warp-trace" },
    spoil_ticks = 2 * second,
    spoil_to_trigger_result = {
      items_per_trigger = 1,
      trigger = {
        type = "direct",
        action_delivery = {
          type = "instant",
          source_effects ={
            {
              type = "script",
              effect_id = "rabbasca_on_trace_spoiled",
            }
          }
        }
      }
    },
    stack_size = 250,
    weight = 0,
  },
},
{
  type = "module",
  name = "rabbasca-stabilizer-reboot-module",
  icon = "__rabbasca-assets__/graphics/recolor/icons/lithium-amide.png",
  icon_size = 128,
  stack_size = 1,
  spoil_ticks = 5 * minute,
  category = "efficiency",
  tier = 10,
  effect = { consumption = -1, speed = -0.1 }
},
{
  type = "fuel-category",
  name = "rabbasca-relicary",
  fuel_value_type = {
    "rabbasca-extra.rabbasca-relicary-fuel-category"
  },
},
{
  type = "item",
  name = "rabbasca-powerspike",
  icons = Rabbasca.icons({
    {proto = data.raw["assembling-machine"]["rabbasca-warp-stabilizer"]},
    {proto = data.raw["virtual-signal"]["signal-unlock"], scale = 0.5}
  }),
  stack_size = 10,
  subgroup = "rabbasca-warp-stabilizer",
  order = "r[relics]-c[upgrade]",
  weight = 250 * kg,
},
{
  type = "item",
  name = "rabbasca-relicary-key",
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/recolor/icons/excitement-rod.png" },
    { icon = data.raw["virtual-signal"]["signal-unlock"].icon, scale = 0.3, shift = { 8, 8 } },
  }),
  icon_size = 64,
  stack_size = 50,
  fuel_value = "100J",
  fuel_category = "rabbasca-relicary",
  subgroup = "rabbasca-warp-stabilizer",
  order = "r[relics]-a[key-unlocked]",
  weight = 1 * kg,
},
{
  type = "item",
  name = "rabbasca-relicary-key-locked",
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/recolor/icons/excitement-rod.png" },
    { icon = data.raw["virtual-signal"]["signal-lock"].icon, scale = 0.3, shift = { 8, 8 } },
  }),
  icon_size = 64,
  stack_size = 50,
  subgroup = "rabbasca-warp-stabilizer",
  order = "r[relics]-a[key-locked]",
  weight = 1 * kg,
},
{
  type = "item",
  name = "rabbasca-warpfield-excitement-rod",
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/by-openai/warp-trace.png", icon_size = 256 },
    { icon = "__rabbasca-assets__/graphics/recolor/icons/excitement-rod.png" },
  }),
  icon_size = 64,
  stack_size = 50,
  subgroup = "rabbasca-warp-stabilizer",
  order = "c[parts]-b[stick]",
  weight = 20 * kg,
},
{
  type = "item",
  name = "rabbasca-warpfield-engine",
  icon = data.raw["item"]["electric-engine-unit"].icon,
  stack_size = 50,
  subgroup = "rabbasca-warp-stabilizer",
  order = "c[parts]-d[engine]",
},
{
  type = "item-with-tags",
  name = "rabbasca-warp-cell-recharging",
  icon = "__rabbasca-assets__/graphics/recolor/icons/warp-cell-empty.png",
  icon_size = 64,
  stack_size = 1,
  localised_description = { "", { "item-description.rabbasca-warp-cell-recharging-tags", "0" }, { "item-description.rabbasca-warp-cell-recharging" } },
  flags = { "not-stackable" },
  spoil_ticks = 30 * second,
  spoil_result = "rabbasca-warp-cell-recharging",
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[warp-anomaly]-c[warp-cell-empty]",
  weight = 250 * kg,
},
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
  icon = "__rabbasca-assets__/graphics/recolor/icons/warp-cell.png",
  icon_size = 64,
  fuel_value = "10MJ",
  fuel_category = "rabbasca-warp-anomaly",
  stack_size = 1,
  flags = { "not-stackable" },
  spoil_ticks = 5 * minute,
  spoil_result = "rabbasca-warp-cell-recharging",
  burnt_result = "rabbasca-warp-cell-recharging",
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[warp-anomaly]-b[warp-cell]",
  weight = 250 * kg,
},
util.merge {
  data.raw["tool"]["automation-science-pack"],
  {
    name = "rabbasca-warp-anomaly",
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
    stack_size = 1000,
    -- fuel_value = "500MJ",
    -- fuel_category = "rabbasca-warp-anomaly",
    weight = 0,
    localised_description = { "item-description.rabbasca-warp-anomaly" },
    spoil_ticks = 20 * second,
    auto_recycle = false,
    subgroup = "rabbasca-warp-stabilizer",
    order = "a[warp-anomaly]",
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
  name = "rabbasca-relicary-remote",
  icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
  place_result = "rabbasca-relicary-remote",
  stack_size = 4,
  weight = 200 * kg,
  subgroup = data.raw["item"]["rabbasca-warp-pylon"].subgroup,
  order = "a[placeable]-x[relicary-remote]",
},
{
  type = "item",
  name = "rabbasca-relichunter",
  icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon.png",
  icon_size = 64,
  place_result = "rabbasca-relichunter",
  stack_size = 50,
  weight = 1000 * kg,
  subgroup = data.raw["item"]["rabbasca-warp-pylon"].subgroup,
  order = data.raw["item"]["rabbasca-warp-pylon"].order.."-r[relichunter]",
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
  name = "rabbasca-stability-pylon",
  icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-2.png",
  icon_size = 64,
  place_result = "rabbasca-stability-pylon",
  stack_size = 5,
  weight = 2000 * kg,
  subgroup = data.raw["item"]["rabbasca-warp-pylon"].subgroup,
  order = data.raw["item"]["rabbasca-warp-pylon"].order.."-r[rabbasca-underground]",
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

local internal_cell = util.merge { 
    data.raw["item"]["rabbasca-warp-cell"],
    {
      name = "rabbasca-warp-cell-internal",
      hidden = true,
      fuel_value = "50MJ",
      spoil_ticks = 0
    }
  }
  internal_cell.spoil_result = nil
  internal_cell.burnt_result = nil
data:extend {
  internal_cell,
  util.merge { 
    internal_cell,
    {
      name = "rabbasca-warp-cell-internal-big",
      fuel_value = "200MJ",
    }
  } 
}