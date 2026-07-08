if settings.startup["rabbasca-interplanetary-construction-3-requires-warpfield-science"].value then
  local warp_tech_3 = data.raw["technology"]["interplanetary-construction-3"]
  warp_tech_3.prerequisites = { "rabbasca-warpfield-science-pack" }
  table.insert(warp_tech_3.unit.ingredients, {"rabbasca-warpfield-science-pack", 1})
end