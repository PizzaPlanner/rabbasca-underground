local M = { }



function M.set_sanity_ui(player)
    local frame = player.gui.relative.rabbasca_sanity_ui
    local value = M.current_insanity(player)
    if value <= 0 or not player.opened_self then
        if frame then frame.destroy() end
        return
    else
        if not frame then
            frame = player.gui.relative.add{
                type = "frame",
                name = "rabbasca_sanity_ui",
                direction = "vertical",
                -- caption = "Sanity",
                anchor = {
                    gui = defines.relative_gui_type.controller_gui,
                    position = defines.relative_gui_position.top
                }
            }
            frame.add { type = "label", name = "sanity_value" }
        end
        local prot = M.get_protection_level(player.character)
        frame.sanity_value.caption = string.format("[item=rabbasca-sanity-loss] Sanity: %.1f%% | [item=rabbasca-tinfoil-hat]: %i", (1- value) * 100, prot)
    end
end

function M.remove_sanity(count, force)
    storage.insanity = storage.insanity or { }
    storage.insanity[force.name] = (storage.insanity[force.name] or 0) + (count or 1)
    for _, player in pairs(force.connected_players) do
        M.set_sanity_ui(player)
    end
end

function M.restore_sanity(count, force)
    storage.insanity = storage.insanity or { }
    storage.insanity[force.name] = math.max(0, (storage.insanity[force.name] or 0) - (count or 1))
    for _, player in pairs(force.connected_players) do
        M.set_sanity_ui(player)
    end
end

function M.on_sanity_loss(level, force)
    if not force then return end
    local count = 1 + level / 5
    for _, player in pairs(force.players) do
        local character = player.character
        if character and character.valid then
            local hats = M.get_protection_level(character)
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

function M.current_insanity(player)
    local base = storage.insanity and storage.insanity[player.force.name] or 0
    return (storage.insanity and storage.insanity[player.force.name] or 0) / 125
end

function M.get_protection_level(character)
    return character and character.grid and (
        character.grid.count("rabbasca-tinfoil-hat")
    ) or 0
end

script.on_nth_tick(1800, function(_)
    if not storage.insanity then return end
    for force, level in pairs(storage.insanity) do
        local chance = math.log(level/2, 10) / 2 + 0.1
        if math.random() < chance then
            M.on_sanity_loss(level, game.forces[force])
        end
    end
end)

return M