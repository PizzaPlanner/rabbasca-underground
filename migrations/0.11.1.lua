local wp = require("scripts.warpotron")
for _, surface in pairs(game.surfaces) do
    for _, e in pairs(surface.find_entities_filtered({ name = "rabbasca-ufo" })) do
        wp.register_warpotron(e)
    end
end