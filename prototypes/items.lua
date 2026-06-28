local item_sounds = require("__base__.prototypes.item_sounds")

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
  name = "rabbasca-stabilizer-warp-sequence",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "a",
  icons = Rabbasca.icons({ proto = data.raw["virtual-signal"]["rabbasca-warp-inventory"], tint = { 0.83, 1, 0.15} })
}, "rabbasca_warp_progress_warp"),
Rabbasca.make_trigger_item({
  name = "rabbasca-amplify-anomaly",
  subgroup = "rabbasca-remote-warping",
  order = "z[destabilize]",
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/recolor/icons/item-warp-slot.png", icon_size = 64 },
    { icon = "__rabbasca-assets__/graphics/icons/warp-anomaly.png", icon_size = 256, scale = 0.25, shift = {0, -3} }
  })
}, "rabbasca_make_floor_anomaly"),
Rabbasca.make_trigger_item({
  name = "rabbasca-progress-powerspike",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "z[destabilize]",
  hidden_in_factoriopedia = true,
  hidden = false,
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/recolor/icons/powerspike-overlay.png", icon_size = 96, shift = {-8, -8} }
  })
}, "rabbasca_on_powerspike_progress"),
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
  name = "rabbasca-floor-stability-upkeep",
  subgroup = "rabbasca-warp-stabilizer-functions",
  order = "zz",
  icons = Rabbasca.icons({
    { proto = data.raw["virtual-signal"]["signal-radioactivity"] }
  })
}, "rabbasca_on_floor_stability"),
Rabbasca.make_trigger_item({
  name = "rabbasca-progress-hunt",
  icon = "__base__/graphics/icons/signal/signal-map-marker.png",
  icon_size = 64,
}, "rabbasca_on_relichunter_progress"),
Rabbasca.make_trigger_item({
  name = "rabbasca-relocate-floorthing",
  icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-3.png",
  icon_size = 64,
}, "rabbasca_on_pylon_relocate"),
Rabbasca.make_trigger_item({
  name = "rabbasca-warpfield-science-pack-wi-download",
  icons = Rabbasca.icons({
    {icon = "__Krastorio2Assets__/icons/entities/stabilizer-charging-station.png", icon_size = 64},
    {proto = data.raw["item"]["rabbasca-warpfield-science-pack"], shift = {8, 8}, scale = 0.3 },
  }),
  subgroup = "rabbasca-vault-extraction",
  order = "v[vault]-f[warpfield-science]",
  hidden = false,
  hidden_in_factoriopedia = false,
}, "rabbasca_on_download_warp_science"),
Rabbasca.make_trigger_item({
  name = "rabbasca-warpfield-science-pack-wi-upload",
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/recolor/icons/item-upload-slot.png", icon_size = 64 },
    { icon = "__rabbasca-assets__/graphics/recolor/icons/warp-science-pack.png", icon_size = 64, scale = 0.25, shift = {0, 3} }
  }),
  hidden = false,
  hidden_in_factoriopedia = false,
  order = "z[upload]",
  subgroup = "rabbasca-remote-warping"
}, "rabbasca_on_upload_warp_science"),
{
  name = "rabbasca-warp-trace",
  type = "item",
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[warp-anomaly]-x[residue]",
  icon = "__rabbasca-assets__/graphics/by-openai/warp-trace.png",
  icon_size = 256,
  spoil_ticks = 2 * second,
  stack_size = 500,
  weight = 0,
  auto_recycle = false,
},
{
  type = "module",
  name = "rabbasca-madness-module",
  icon = "__rabbasca-assets__/graphics/recolor/icons/madness-module.png",
  icon_size = 64,
  stack_size = 50,
  spoil_ticks = 1 * minute,
  spoil_result = "rabbasca-madness-module-low",
  category = "speed",
  tier = 10,
  effect = { speed = 3, quality = 1 }
},
{
  type = "module",
  name = "rabbasca-madness-module-low",
  icon = "__rabbasca-assets__/graphics/recolor/icons/madness-module-off.png",
  icon_size = 64,
  stack_size = 50,
  spoil_ticks = 1 * minute,
  spoil_result = "rabbasca-madness-module",
  category = "speed",
  tier = 10,
  localised_description = { "item-description.rabbasca-madness-module" },
  effect = { speed = 4, quality = -1 }
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
    {icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png", icon_size = 640 },
    {icon = "__rabbasca-assets__/graphics/recolor/icons/powerspike-overlay.png", icon_size = 96 }
  }),
  stack_size = 10,
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[stabilizer]-a[upgrade]",
  weight = 250 * kg,
  fuel_value = "100J",
  fuel_category = "rabbasca-relicary",
  auto_recycle = false,
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
  icon = "__rabbasca-assets__/graphics/recolor/icons/warpfield-engine.png",
  icon_size = 64,
  stack_size = 50,
  subgroup = "rabbasca-warp-stabilizer",
  order = "c[parts]-d[engine]",
},
{
  type = "item-with-inventory",
  name = "rabbasca-warp-cell-recharging",
  icon = "__rabbasca-assets__/graphics/recolor/icons/warp-cell-empty.png",
  icon_size = 64,
  stack_size = 1,
  inventory_size = 1, -- cannot open otherwise
  flags = { "not-stackable", "mod-openable", "hide-health-bar-in-world" },
  -- spoil_ticks = 30 * second,
  -- spoil_result = "rabbasca-warp-cell-recharging",
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[warp-anomaly]-c[warp-cell-empty]",
  auto_recycle = false,
  weight = 250 * kg,
},
{
  type = "item-with-inventory",
  name = "rabbasca-warp-cell",
  icon = "__rabbasca-assets__/graphics/recolor/icons/warp-cell.png",
  icon_size = 64,
  inventory_size = 1, -- cannot open otherwise
  fuel_value = "10MJ",
  fuel_category = "rabbasca-warp-anomaly",
  stack_size = 1,
  flags = { "not-stackable", "mod-openable", "hide-health-bar-in-world" },
  spoil_ticks = 4 * minute,
  spoil_result = "rabbasca-warp-cell-recharging",
  burnt_result = "rabbasca-warp-cell-recharging",
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[warp-anomaly]-b[warp-cell]",
  auto_recycle = false,
  weight = 250 * kg,
},
{
  type = "item",
  name = "rabbasca-lithium-amide",
  icon = "__rabbasca-assets__/graphics/recolor/icons/lithium-amide.png",
  icon_size = 128,
  stack_size = 50,
  fuel_value = "40MJ",
  fuel_category = "chemical",
  burnt_result = "lithium",
  weight = 25 * kg,
  auto_recycle = false,
  subgroup = "rabbasca-processes",
  order = "u[underground]-a[resources]-a[amide]"
},
{
  name = "rabbasca-warp-anomaly",
  type = "item",
  icon = "__rabbasca-assets__/graphics/icons/warp-anomaly.png",
  icon_size = 256,
  -- icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
  -- icon_size = 1024,
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
{
  type = "item",
  name = "rabbasca-quantum-device",
  icon = "__rabbasca-assets__/graphics/recolor/icons/quantum-device.png",
  icon_size = 64,
  stack_size = 100,
  weight = 50 * kg,
  subgroup = "rabbasca-warp-stabilizer",
  order = "b[science]-b",
},
{
  type = "item",
  name = "rabbasca-obscure-theories",
  icon = "__rabbasca-assets__/graphics/recolor/icons/rabbascan-papers.png",
  icon_size = 64,
  stack_size = 200,
  weight = 1 * kg,
  auto_recycle = false,
  subgroup = "rabbasca-relics",
  order = "b[relicary]-a[theories]"
},
{
  type = "item",
  name = "rabbasca-restored-knowledge",
  icon = "__rabbasca-assets__/graphics/recolor/icons/solved-papers.png",
  icon_size = 64,
  stack_size = 200,
  weight = 1 * kg,
  auto_recycle = false,
  subgroup = "rabbasca-relics",
  order = "b[relicary]-b[restored]"
},
util.merge {
  data.raw["item"]["automation-science-pack"],
  {
    name = "rabbasca-warpfield-science-pack",
    icon = "__rabbasca-assets__/graphics/recolor/icons/warp-science-pack.png",
    icon_size = 64,
    auto_recycle = false,
    localised_description = { "item-description.rabbasca-warpfield-science-pack" },
    subgroup = "science-pack",
    order = "k-r[rabbasca]",
  },
},
{
  type = "item",
  name = "rabbasca-spacetime-sensor",
  icons = Rabbasca.icons({
    { proto = data.raw["item"]["display-panel"], },
    { icon = "__rabbasca-assets__/graphics/by-openai/warp-trace.png", icon_size = 256, scale = 0.25, shift = { -4, -4} }
  }),
  stack_size = 50,
  weight = 5 * kg,
  auto_recycle = true,
  subgroup = "rabbasca-processes",
  order = "u[underground]-b[products]-a[sensor]"
},
{
  type = "item",
  name = "rabbasca-relicary-remote",
  icons = Rabbasca.icons({ proto = data.raw["assembling-machine"]["rabbasca-vault-console"] }),
  place_result = "rabbasca-relicary-remote",
  stack_size = 4,
  weight = 200 * kg,
  subgroup = "rabbasca-relics",
  order = "b[relicary-access]-0[access]"
},
{
  type = "item",
  name = "rabbasca-remote-access-chest",
  icon = "__rabbasca-assets__/graphics/recolor/icons/nearby-access.png",
  icon_size = 64,
  place_result = "rabbasca-remote-access-chest",
  stack_size = 50,
  weight = 100 * kg,
  subgroup = "storage",
  order = "a[items]-x[remote-access]",
},
{
  type = "item",
  name = "rabbasca-relichunter",
  icon = "__rabbasca-assets__/graphics/by-hurricane/research-center-icon.png",
  icon_size = 64,
  place_result = "rabbasca-relichunter",
  stack_size = 50,
  weight = 1000 * kg,
  subgroup = "rabbasca-relics",
  order = "a[hunter]",
},
{
  type = "item",
  name = "rabbasca-collector-pylon",
  icon = "__rabbasca-assets__/graphics/recolor/icons/cpylon.png",
  icon_size = 64,
  place_result = "rabbasca-collector-pylon",
  stack_size = 10,
  weight = 100 * kg,
  auto_recycle = false,
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[stabilizer]-b[collector]",
},
{
  name ="rabbasca-stability-pylon",
  type = "item",
  icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-3.png",
  icon_size = 64,
  stack_size = 10,
  weight = 100 * kg,
  auto_recycle = false,
  place_result = "rabbasca-stability-pylon",
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[stabilizer]-b[stability]",
},
{
  name = "rabbasca-ufo",
  type = "item",
  icon = "__rabbasca-assets__/graphics/recolor/icons/warpotron.png",
  icon_size = 64,
  place_result = "rabbasca-ufo",
  stack_size = 1,
  weight = 5000 * kg,
  subgroup = "transport",
  order = "b[personal-transport]-c[spidertron]-r[warpotron]",
}
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
    data.raw["item-with-inventory"]["rabbasca-warp-cell"],
    {
      type = "item",
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