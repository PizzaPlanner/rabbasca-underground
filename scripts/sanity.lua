local INSANITY_LIMIT = 125
local M = { 
    DEFAULT_DRAIN = 0.005,
    DEFAULT_RESTORE = 0.001,
    DEFAULT_CHECK_INTERVAL = 15 * 60,
    DEFAULT_BUFF_INTERVAL = 90,
    SPAWN_WHERE_LOOKING = true,
}

if data then return M end

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

function M.spawn_crawler(surface, position, force)
    local c = surface.create_segmented_unit({
        name = "rabbasca-small-insanity-crawler",
        position = { position.x + math.random(-36, 36), position.y + math.random(-36, 36) },
        force = force,
        extended = false,
    })
    if c then
        c.set_ai_state({
            type = defines.segmented_unit_ai_state.enraged_at_nothing,
            -- target = character
            destination = position,
            last_damage_time = game.tick
        })
        c.minimum_activity_mode  = defines.segmented_unit_activity_mode.full
        c.speed = c.target_speed
    end
end

function M.spawn_wriggler(surface, position, force)
    surface.create_entity({
        name = "rabbasca-small-insanity-wriggler",
        position = { position.x + math.random(-14, 14), position.y + math.random(-14, 14) },
        force = force
    })
end

function M.spawn_egg(surface, position, force)
    surface.create_entity({
        name = "rabbasca-insanity-spawner",
        position = { position.x + math.random(-19, 19), position.y + math.random(-19, 19) },
        force = force
    })
end

function M.on_sanity_tick(character)
    if not character.valid then return end
    local value = M.current_insanity(character)
    if value <= 0 then return end
    local prot  = M.get_protection_level(character)
    if prot > 1 then return end
    local force = prot > 0 and character.force or game.forces.enemy
    if value > 0.1 then
        character.health = math.max(character.health - 50, (1 - value) * character.max_health + 1)
    end
    local surface  = M.SPAWN_WHERE_LOOKING and character.player and character.player.surface or character.surface
    local position = M.SPAWN_WHERE_LOOKING and character.player and character.player.position or character.position
    if not character.force.is_chunk_visible(surface, { x = math.floor(position.x / 32), y = math.floor(position.y / 32) }) then return end
    if math.random() < (value - 0.1)/11 + 0.02 then
        M.spawn_egg(surface, position, force)
    end
    if math.random() < 1.3 * value - 0.6 then 
        M.spawn_crawler(surface, position, force)
    end
    local l = math.log(value + 0.1, 10) / 2
    if math.random() < l then 
        M.spawn_wriggler(surface, position, force)
        M.spawn_wriggler(surface, position, force)
    end
    if math.random() < l - 0.1 then 
        M.spawn_wriggler(surface, position, force)
        M.spawn_wriggler(surface, position, force)
    end
    if math.random() < l - 0.2 then 
        M.spawn_wriggler(surface, position, force)
        M.spawn_wriggler(surface, position, force)
        M.spawn_wriggler(surface, position, force)
    end
end

function M.on_sanity_loss(level, player)
    local character = player.character
    if not (character and character.valid) then return end
    local hats = M.get_protection_level(character)
    if hats > 1 then return end
    if hats > 0 then
        character.surface.create_entity {
            name = "rabbasca-insanity-sticker-buff",
            position = character.position,
            target = character
        }
    else
        character.surface.create_entity {
            name = "rabbasca-insanity-sticker-debuff",
            position = character.position,
            target = character
        }
    end
end

function M.remove_sanity(force, count)
    storage.insanity = storage.insanity or { }
    storage.insanity[force.name] = math.min(INSANITY_LIMIT, (storage.insanity[force.name] or 0) + (count or M.DEFAULT_DRAIN) * INSANITY_LIMIT)
    for _, player in pairs(force.connected_players) do
        M.set_sanity_ui(player)
    end
end

function M.restore_sanity(force, count)
    storage.insanity = storage.insanity or { }
    storage.insanity[force.name] = math.max(0, (storage.insanity[force.name] or 0) - (count or M.DEFAULT_RESTORE) * INSANITY_LIMIT)
    if storage.insanity[force.name] <= 0 then
        storage.insanity[force.name] = nil
    end
    for _, player in pairs(force.connected_players) do
        M.set_sanity_ui(player)
    end
end

function M.set_insanity(level, player)
    local force = player.force
    storage.insanity = storage.insanity or { }
    storage.insanity[force.name] = math.max(0, math.min(INSANITY_LIMIT, level * INSANITY_LIMIT))
    if storage.insanity[force.name] <= 0 then
        storage.insanity[force.name] = nil
    end
    for _, p in pairs(force.connected_players) do
        M.set_sanity_ui(p)
    end
end

function M.current_insanity(player)
    return math.min(1, (storage.insanity and storage.insanity[player.force.name] or 0) / INSANITY_LIMIT)
end

function M.get_protection_level(character)
    return character and character.grid and (
        character.grid.count("rabbasca-tinfoil-hat")
    ) or 0
end

script.on_nth_tick(M.DEFAULT_CHECK_INTERVAL, function(_)
    if not storage.insanity then return end
    for f, level in pairs(storage.insanity) do
        local force = game.forces[f]
        if force then
            for _, player in pairs(force.connected_players) do
                M.on_sanity_loss(level, player)
            end
        else
            storage.insanity[f] = nil
        end
    end
end)

if settings.global["rabbasca-debug-mode"] then
    commands.add_command("rabbasca_ug_sani", nil, function(command)
        local to = tonumber(command.parameter) or 1
        M.set_insanity(to, game.players[command.player_index])
    end)
end

return M