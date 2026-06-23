for _, lab in pairs(data.raw["lab"]) do
  for _, input in pairs(lab.inputs) do
    if input == "athletic-science-pack" then
      table.insert(lab.inputs, "rabbasca-warpfield-science-pack")
      break
    end
  end
end