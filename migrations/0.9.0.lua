local sanity = require("scripts.sanity")
if not storage.insanity then return end
storage.access_whitelist = storage.access_whitelist or { }

for f, value in pairs(storage.insanity) do
    if game.forces[f] then
        for _, player in pairs(game.forces[f].players) do
            storage.access_whitelist[player.index] = true
            sanity.set_insanity(value / 125, player)
        end
        storage.insanity[f] = nil
    end
end