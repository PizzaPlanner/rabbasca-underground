for _, lab in pairs(data.raw["lab"]) do
  for _, input in pairs(lab.inputs) do
    if input == "automation-science-pack" then
      table.insert(lab.inputs, "rabbasca-warpfield-science-pack")
      table.insert(lab.inputs, "rabbasca-imaginary-science-pack")
      break
    end
  end
end

data.raw["recipe"]["rabbasca-warp-pylon"].hidden = false
data.raw["recipe"]["rabbasca-warp-pylon"].hidden_in_factoriopedia = false
data.raw["recipe"]["rabbasca-warp-pylon"].factoriopedia_alternative = "rabbasca-warp-pylon"

require("compatibility.carna-updates")