local function bonus_icon(proto)
  return Rabbasca.icons({
    { proto = proto, icon_size = 64 },
    { proto = data.raw["virtual-signal"]["signal-1"], icon_size = 64, scale = 0.3, shift = { 8, 8 } },
  })
end

local function make_spike_tech(level, unlocks)
  data:extend({
  {
    type = "technology",
    name = "rabbasca-warp-stabilizer-powerspike-"..level,
    icon = "__rabbasca-assets__/graphics/by-openai/warp-matrix.png",
    icon_size = 1024,
    rabbasca_underground_temporary = true,
    prerequisites = { level == 1 and "rabbasca-underground" or "rabbasca-warp-stabilizer-powerspike-"..(level - 1) },
    effects = unlocks or  { },
    research_trigger =
    {
      type = "scripted",
      trigger_description = { "rabbasca-extra.trigger-unlock-powerspike", tostring(level) }
    }
  } 
  })
end

make_spike_tech(1)
make_spike_tech(2, {{ type = "unlock-recipe", recipe = "rabbasca-stabilizer-warp-sequence" }})
make_spike_tech(3)
make_spike_tech(4)
make_spike_tech(5, {{ type = "unlock-recipe", recipe = "rabbasca-collector-pylon" }})
make_spike_tech(6)
make_spike_tech(7)
make_spike_tech(8, {{ type = "unlock-recipe", recipe = "rabbasca-stability-pylon" }})
make_spike_tech(9)
make_spike_tech(10, {{ type = "unlock-recipe", recipe = "rabbasca-warp-cell-recharging" }})