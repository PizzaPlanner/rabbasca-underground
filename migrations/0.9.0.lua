local sanity = require("scripts.sanity")
if not storage.insanity then return end

for f, value in pairs(storage.insanity) do
    if game.forces[f] then
        for _, player in pairs(game.forces[f].players) do
            sanity.on_unlock_sanity(player)
            sanity.set_insanity(value / 125, player)
        end
        storage.insanity[f] = nil
    end
end