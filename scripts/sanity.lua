local M = { }

function M.remove_sanity(count, force)
    storage.insanity = storage.insanity or { }
    storage.insanity[force.name] = (storage.insanity[force.name] or 0) + (count or 1)
end

function M.restore_sanity(count, force)
    storage.insanity = storage.insanity or { }
    storage.insanity[force.name] = math.max(0, (storage.insanity[force.name] or 0) - (count or 1))
end

function M.on_sanity_loss(level, force)
    if not force then return end
    local count = 1 + level / 5
    for _, player in pairs(force.players) do
        local character = player.character
        if character and character.valid then
            local hats = character.grid and character.grid.count("rabbasca-tinfoil-hat") or 0
            if hats < 2 then
                for i = 1, count do
                    character.surface.create_entity({
                        name = "rabbasca-small-insanity-wriggler",
                        position = { character.position.x + math.random(-4, 4), character.position.y + math.random(-4, 4) },
                        force = hats > 0 and player.force or game.forces.rabbascans
                    })
                end
            end
        end
    end
end

script.on_nth_tick(1800, function(_)
    if not storage.insanity then return end
    for force, level in pairs(storage.insanity) do
        local chance = math.log(level, 10) / 2 - 0.1
        if math.random() < chance then
            M.on_sanity_loss(level, game.forces[force])
        end
    end
end)

return M