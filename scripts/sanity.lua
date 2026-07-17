local M = { 
    DEFAULT_DRAIN = 0.005,
    DEFAULT_RESTORE = 0.001,
    DEFAULT_CHECK_INTERVAL = 15 * 60,
    DEFAULT_BUFF_INTERVAL = 90,
    DEFAULT_RESPAWN_PROTECTION = 120 * 60,
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
    local w = surface.create_entity({
        name = "rabbasca-small-insanity-wriggler",
        position = { position.x + math.random(-14, 14), position.y + math.random(-14, 14) },
        force = force
    })
    w.commandable.set_command({
        type = defines.command.attack_area,
        destination = position,
        radius = 16,
        distraction = defines.distraction.by_anything
    })
end

function M.on_sanity_tick(character)
    if not character.valid then return end
    local value = M.current_insanity(character.player)
    if value <= 0 then return end
    local prot  = M.get_protection_level(character)
    if prot > 1 then return end
    local force = prot > 0 and character.force or game.forces.enemy
    -- if value > 0.1 then
    --     character.health = math.max(character.health - 50, (1 - value) * character.max_health + 1)
    -- end
    local surface  = M.SPAWN_WHERE_LOOKING and character.player and character.player.surface or character.surface
    local position = M.SPAWN_WHERE_LOOKING and character.player and character.player.position or character.position
    if not character.force.is_chunk_visible(surface, { x = math.floor(position.x / 32), y = math.floor(position.y / 32) }) then return end
    local l = math.log(1.75* value + 0.33) / 3 + 0.4
    if math.random() < l then 
        M.spawn_wriggler(surface, position, force)
        M.spawn_wriggler(surface, position, force)
    end
    if math.random() < 2.5 * l - 1 then 
        M.spawn_crawler(surface, position, force)
    end
    if math.random() < 1.5 * l - 0.3 then 
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

function M.on_player_died(player)
    if not (storage.insanity and storage.insanity[player.index]) then return end
    storage.insanity[player.index].respawn_protection = game.tick + M.DEFAULT_RESPAWN_PROTECTION
    M.restore_sanity(player, 0.05)
end

function M.remove_sanity(player, count)
    if not player then return end
    M.set_insanity(M.current_insanity(player) + (count or M.DEFAULT_DRAIN), player)
end

function M.restore_sanity(player, count)
    if not (player and storage.insanity[player.index]) then return end
    M.set_insanity(M.current_insanity(player) - (count or M.DEFAULT_RESTORE), player)
end

function M.set_insanity(level, player)
    storage.insanity = storage.insanity or { }
    local data = storage.insanity[player.index]
    if not data then return end
    data.value = math.max(0, math.min(1, level))
    if data.value > (data.highest_value or 0) then
        M.on_new_sanity_record(player, data.value, (data.highest_value or 0))
        data.highest_value = data.value
    end
    storage.insanity[player.index] = data
    M.set_sanity_ui(player)
end

function M.current_insanity(player)
    return math.min(1, (storage.insanity and storage.insanity[player.index] or { value = 0 }).value)
end

function M.on_new_sanity_record(player, new_value, prev_record)
    if prev_record <= 0 then
        player.print({"rabbasca-extra.sanity-notice-0"})
    end
    for i = 1,10 do
        if new_value * 10 >= i and prev_record * 10 < i then
            player.print({"rabbasca-extra.sanity-notice-"..i})
        end
    end
end

function M.on_unlock_sanity(player)
    storage.insanity = storage.insanity or { }
    storage.insanity[player.index] = storage.insanity[player.index] or { value = 0, respawn_protection = 0, highest_value = 0 }
end

function M.get_protection_level(character)
    return character and character.grid and (
        character.grid.count("rabbasca-tinfoil-hat")
    ) or 0
end

script.on_nth_tick(M.DEFAULT_CHECK_INTERVAL, function(_)
    if not storage.insanity then return end
    local tick = game.tick
    for id, data in pairs(storage.insanity) do
        if data.value > 0 and (data.respawn_protection or 0) < tick then
            local player = game.players[id]
            if not player then
                -- TODO: player.index can be reused
                -- if time between removal and reuse can be < DEFAULT_CHECK_INTERVAL, also need cleanup via on_player_removed
                storage.insanity[id] = nil
                break
            end
            if player.connected then
                data.respawn_protection = nil
                M.on_sanity_loss(data.value, player)
            end
        end
    end
end)

if settings.global["rabbasca-debug-mode"].value then
    commands.add_command("rabbasca_ug_sani", nil, function(command)
        local to = tonumber(command.parameter) or 1
        M.set_insanity(to, game.players[command.player_index])
        game.players[command.player_index].print(serpent.line(storage.insanity))
    end)
end

return M