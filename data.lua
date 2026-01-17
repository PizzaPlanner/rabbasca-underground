require("prototypes.map-gen")
require("prototypes.items")
require("prototypes.entities")
require("prototypes.resources")
require("prototypes.surfaces")
require("prototypes.recipes")
require("prototypes.tiles")
require("prototypes.technologies")
require("prototypes.tips-and-tricks")
require("prototypes.materialize")

data.raw["recipe"]["rabbasca-warp-pylon"].hidden = false
data.raw["recipe"]["rabbasca-warp-pylon"].hidden_in_factoriopedia = false
data.raw["recipe"]["rabbasca-warp-pylon"].factoriopedia_alternative = "rabbasca-warp-pylon"

data.raw["tile"]["harenic-lava"].autoplace = { probability_expression = "rabbasca_underground_lava" }