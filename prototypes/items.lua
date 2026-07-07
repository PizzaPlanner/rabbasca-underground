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
  subgroup = "rabbasca-events",
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
  subgroup = "rabbasca-events",
  order = "z[destabilize]",
  hidden_in_factoriopedia = true,
  hidden = false,
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/recolor/icons/powerspike-overlay.png", icon_size = 96 }
  })
}, "rabbasca_on_powerspike_progress"),
Rabbasca.make_trigger_item({
  name = "rabbasca-abandon-stabilizer",
  subgroup = "rabbasca-events",
  order = "zz",
  icons = Rabbasca.icons({
    { proto = data.raw["virtual-signal"]["signal-explosion"] }
  })
}, "rabbasca_on_abandon"),
Rabbasca.make_trigger_item({
  name = "rabbasca-summon-ufo",
  subgroup = "rabbasca-security",
  order = "w[warpotron-call]",
  hidden = false,
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/recolor/icons/warpotron.png", icon_size = 64, },
    { proto = data.raw["virtual-signal"]["rabbasca-warp-inventory"], scale = 0.5, shift = {8,8} },
  })
}, "rabbasca_on_summon_ufo"),
Rabbasca.make_trigger_item({
  name = "rabbasca-floor-stability-upkeep",
  subgroup = "rabbasca-events",
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
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/by-hurricane/conduit-icon-3.png", icon_size = 64 },
    { proto = data.raw["virtual-signal"]["signal-shuffle"], scale = 0.5, shift = { 8, 8 } },
  }),
}, "rabbasca_on_pylon_relocate"),
Rabbasca.make_trigger_item({
  name = "rabbasca-warpfield-science-pack-wi-download",
  icons = Rabbasca.icons({
    { icon = "__Krastorio2Assets__/icons/entities/stabilizer-charging-station.png", icon_size = 64 },
    { icon = "__rabbasca-assets__/graphics/recolor/icons/warp-science-pack.png", icon_size = 64, shift = {8, 8}, scale = 0.75 },
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
    { icon = "__rabbasca-assets__/graphics/recolor/icons/warp-science-pack.png", icon_size = 64, scale = 0.5, shift = {0, 3} }
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
  order = "w[warp-anomaly]-x[residue]",
  icon = "__rabbasca-assets__/graphics/by-openai/warp-trace.png",
  icon_size = 256,
  spoil_ticks = 2 * second,
  stack_size = 500,
  weight = 0,
  auto_recycle = false,
},
{
  type = "module",
  name = "rabbasca-supercharged-module",
  icon = "__rabbasca-assets__/graphics/recolor/icons/supercharged-module.png",
  icon_size = 64,
  stack_size = 50,
  category = "speed",
  tier = 10,
  effect = { speed = 3 },
  order = "a[speed]-r[rabbasca]",
  subgroup = "module"
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
  stack_size = 20,
  subgroup = "rabbasca-warp-stabilizer",
  order = "a[stabilizer]-a[upgrade]",
  weight = 250 * kg,
  auto_recycle = false,
},
{
  type = "item",
  name = "rabbasca-powerspike-weak",
  icons = Rabbasca.icons({
    {icon = "__rabbasca-assets__/graphics/by-hurricane/atom-forge-icon.png", icon_size = 640 },
    {icon = "__rabbasca-assets__/graphics/recolor/icons/powerspike-overlay.png", icon_size = 96 },
    { icon = "__base__/graphics/icons/signal/signal-battery-low.png", icon_size = 64, shift = {-8, 8}, scale = 0.5 }
  }),
  stack_size = 20,
  spoil_ticks = 30 * minute,
  spoil_result = "rabbasca-powerspike",
  subgroup = "rabbasca-events",
  order = "a[stabilizer]-o",
  weight = 250 * kg,
  auto_recycle = false,
},
{
  type = "item",
  name = "rabbasca-powershard",
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/icons/archive.png", icon_size = 128 },
    { icon = "__base__/graphics/icons/signal/signal-battery-full.png", icon_size = 64, shift = { 8, 8 }, scale = 0.5 }
  }),
  stack_size = 200,
  subgroup = "rabbasca-events",
  order = "a[stabilizer]-n",
  weight = 25 * kg,
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
  subgroup = "rabbasca-ug-processes",
  order = "b[products]-c[stick]",
  weight = 20 * kg,
},
{
  type = "item",
  name = "rabbasca-warpfield-engine",
  icon = "__rabbasca-assets__/graphics/recolor/icons/warpfield-engine.png",
  icon_size = 64,
  stack_size = 50,
  subgroup = "rabbasca-ug-processes",
  order = "b[products]-d[engine]",
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
  order = "w[warp-anomaly]-c[warp-cell-empty]",
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
  order = "w[warp-anomaly]-b[warp-cell]",
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
  subgroup = "rabbasca-ug-processes",
  order = "a[resources]-a[amide]"
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
  order = "w[warp-anomaly]",
},
{
  type = "item",
  name = "rabbasca-quantum-device",
  icon = "__rabbasca-assets__/graphics/recolor/icons/quantum-device.png",
  icon_size = 64,
  stack_size = 100,
  weight = 50 * kg,
  subgroup = "rabbasca-ug-processes",
  order = "w[warp]-a[warp-container]",
},
{
  type = "item",
  name = "rabbasca-obscure-theories",
  icon = "__rabbasca-assets__/graphics/recolor/icons/rabbascan-papers.png",
  icon_size = 64,
  stack_size = 200,
  weight = 1 * kg,
  auto_recycle = false,
  subgroup = "rabbasca-ug-processes",
  order = "r[relicary]-a[theories]"
},
{
  type = "item",
  name = "rabbasca-restored-knowledge",
  icon = "__rabbasca-assets__/graphics/recolor/icons/solved-papers.png",
  icon_size = 64,
  stack_size = 200,
  weight = 1 * kg,
  auto_recycle = false,
  subgroup = "rabbasca-ug-processes",
  order = "r[relicary]-b[restored]"
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
    { icon = "__rabbasca-assets__/graphics/by-openai/warp-trace.png", icon_size = 256, scale = 0.5, shift = { -4, -4 } }
  }),
  stack_size = 50,
  weight = 5 * kg,
  auto_recycle = true,
  subgroup = "rabbasca-ug-processes",
  order = "b[products]-a[sensor]"
},
{
  type = "item",
  name = "rabbasca-relicary-remote",
  icons = Rabbasca.icons({
    { icon = "__rabbasca-assets__/graphics/icons/archive.png", icon_size = 128 },
    { proto = data.raw["virtual-signal"]["signal-upwards-downwards-arrow"], scale = 0.5, shift = { 8, 8 } },
  }),
  place_result = "rabbasca-relicary-remote",
  stack_size = 4,
  weight = 200 * kg,
  subgroup = "storage",
  order = "a[items]-x[relicary-access]"
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
  subgroup = "rabbasca-warp-stabilizer",
  order = "h[hunter]",
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
},
{
  name = "rabbasca-tinfoil-hat",
  type = "item",
  place_as_equipment_result = "rabbasca-tinfoil-hat",
  icon = "__rabbasca-assets__/graphics/recolor/icons/tinfoil-hat.png",
  icon_size = 64,
  stack_size = 10,
  weight = 1 * kg,
  subgroup = "utility-equipment",
  order = "h[tinfoil-hat]",
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
      fuel_value = "100MJ",
    }
  }
}