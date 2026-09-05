local M = { 
    EXTEND_PANIC_DURATION = 10 * 60,
    MAX_PANIC_DURATION = 600 * 60,
    INITIAL_PANIC_DURATION = 30 * 60,
    DURATION_MULT_HAT = 0.5,
    DEFAULT_BUFF_INTERVAL = 4 * 60,
    SPAWN_WHERE_LOOKING = settings.startup["rabbasca-insanity-where-looking"].value,
}

if data then return M end

local QUALITY_LEVELS = { }
for _, q in pairs(prototypes.quality) do
    QUALITY_LEVELS[q.name] = { level = q.level, mult = q.default_multiplier }
end

function M.insert_fuel(from, quality)
    if not (from and from.valid) then return end
    local player = from.is_entity_with_owner and from.last_user
    if not (player and player.connected and player.character) then return end
    local items = {name = "rabbasca-rampant-imagination", count = 1, quality = quality}
    player.character.insert(items)
end

function M.do_panic_attack(event, quality)
    local from = event.source_entity
    local player = nil
    if from and from.valid then
        player = (from.is_entity_with_owner and from.last_user) or (from.type == "character" and from.player)
    end
    if not (player and player.connected and player.character and storage.access_whitelist[player.index]) then
        local surface = from and from.surface or game.surfaces[event.surface_index]
        local pos = from and from.position or event.source_position
        if surface and pos then
            for _ = 1,math.random(3,7) do
                M.spawn_wriggler(surface, pos, game.forces.enemy, quality)
            end
        end
        return
    end
    local target = player.character
    local has_hat = M.get_protection_level(target) > 0
    local sticker = has_hat and "rabbasca-insanity-sticker-buff" or "rabbasca-insanity-sticker-debuff"
    local time_mult = has_hat and M.DURATION_MULT_HAT or 1
    for _, e in pairs(target.stickers or { }) do
        if e.name == sticker then
            local q_data = QUALITY_LEVELS[quality or "normal"]
            local added = M.EXTEND_PANIC_DURATION * time_mult * q_data.mult * q_data.mult
            if e.quality.level >= q_data.level then
                e.time_to_live = e.time_to_live + added
            else
                local ttl = e.time_to_live + added
                e.surface.create_entity { -- new sticker replaces old one automatically
                    name = sticker,
                    position = e.position,
                    target = e.sticked_to,
                    quality = quality
                }.time_to_live = ttl
            end
            return
      end
    end
    target.surface.create_entity {
        name = sticker,
        position = target.position,
        target = target,
        quality = quality
    }.time_to_live = M.INITIAL_PANIC_DURATION * time_mult
end

function M.get_insanity(character)
    local sani = 0
    local quali = "normal"
    for _, s in pairs(character.stickers or { }) do
        if s.name:find("^rabbasca%-insanity%-sticker") then
            sani = math.max(sani, M.get_insanity_stage(s))
            if QUALITY_LEVELS[s.quality.name].level > QUALITY_LEVELS[quali].level then quali = s.quality.name end
        end
    end
    return sani, quali
end

function M.get_insanity_stage(sticker)
    return sticker.time_to_live / M.MAX_PANIC_DURATION
end


function M.spawn_crawler(surface, position, force, quality)
    local c = surface.create_segmented_unit({
        name = "rabbasca-small-insanity-crawler",
        position = { position.x + math.random(-36, 36), position.y + math.random(-36, 36) },
        force = force,
        extended = false,
        quality = quality
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

function M.spawn_snagger(surface, position, force, quality)
    local c = surface.create_entity({
        name = "rabbasca-insanity-logistic-robot",
        position = { position.x + math.random(-8, 8), position.y + math.random(-8, 8) },
        force = force,
        quality = quality
    })
end

function M.spawn_wriggler(surface, position, force, quality)
    local w = surface.create_entity({
        name = "rabbasca-small-insanity-wriggler",
        position = { position.x + math.random(-14, 14), position.y + math.random(-14, 14) },
        force = force,
        quality = quality
    })
    w.commandable.set_command({
        type = defines.command.attack_area,
        destination = position,
        radius = 16,
        distraction = defines.distraction.by_anything
    })
end

function M.on_sanity_tick(sticker)
    if not sticker.valid then return end
    local character = sticker.sticked_to
    if not character.valid then return end
    
    local value = M.get_insanity_stage(sticker)
    if value <= 0 then return end
    character.player.create_local_flying_text { 
        text = { "rabbasca-extra.i-feel-insane", string.format("%i", value * 100), quality = sticker.quality.name }, 
        position = { x = character.position.x, y = character.position.y - 2 }, 
        surface = character.surface,
        time_to_live = 60,
        speed = 1
    }
    local is_friend = sticker.name == "rabbasca-insanity-sticker-buff"
    local force = is_friend and character.force or game.forces.enemy
    local surface  = M.SPAWN_WHERE_LOOKING and character.player and character.player.surface or character.surface
    local position = M.SPAWN_WHERE_LOOKING and character.player and character.player.position or character.position
    if not character.force.is_chunk_visible(surface, { x = math.floor(position.x / 32), y = math.floor(position.y / 32) }) then return end
    character.begin_crafting { count = 4, recipe = "rabbasca-psychosis", silent = true }
    local l = math.log(1.75* value + 0.33) / 3 + 0.4
    if math.random() < l then 
        M.spawn_wriggler(surface, position, force, sticker.quality)
        M.spawn_wriggler(surface, position, force, sticker.quality)
    end
    if math.random() < 2.5 * l - 1 then 
        M.spawn_crawler(surface, position, force, sticker.quality)
    end
    if math.random() < 1.5 * l - 0.3 then 
        M.spawn_wriggler(surface, position, force, sticker.quality)
        M.spawn_wriggler(surface, position, force, sticker.quality)
        M.spawn_wriggler(surface, position, force, sticker.quality)
    end
    if math.random() < 1.5 * l - 0.4 then 
        if is_friend then
            if surface.find_logistic_network_by_position(position, force) then
                M.spawn_snagger(surface, position, force, sticker.quality)
                M.spawn_snagger(surface, position, force, sticker.quality)
            end
        end
    end
end

function M.get_protection_level(character)
    return character and character.grid and (
        character.grid.count("rabbasca-tinfoil-hat")
    ) or 0
end

script.on_event(defines.events.on_worker_robot_expired, function(event)
    if event.robot.name == "rabbasca-insanity-logistic-robot" then
        local inv = event.robot.get_inventory(defines.inventory.robot_cargo)
        if inv then
            event.robot.surface.spill_inventory{ position = event.robot.position, inventory = inv, enable_looted = true, force = event.robot.force, drop_full_stack = true }
        end
    end
end)

script.on_event(defines.events.on_player_crafted_item, function(event)
    if not (event.recipe.categories[1] == "rabbasca-psychosis-manual" and #event.recipe.categories == 1) then return end
    local character = game.players[event.player_index].character
    if not (character and character.valid) then return end
    local sanity, quality = M.get_insanity(character)
    if sanity <= 0 then
        character.player.create_local_flying_text { 
            text = { "rabbasca-extra.crafting-aborted-no-psychosis" },
            position = { x = character.position.x, y = character.position.y - 2 },
            surface = character.surface,
        }
        event.item_stack.clear()
    elseif event.item_stack and quality ~= "normal" then
        event.item_stack.set_stack({
            name = event.item_stack.name,
            quality = quality,
            spoil_percent = event.item_stack.spoil_percent,
            count = event.item_stack.count
        })
    end
end)

script.on_event(prototypes.recipe["rabbasca-hellvent-refreshing"].on_crafted_event, function(event)
    local inv = game.create_inventory(10)
    local e, _ = event.entity.apply_upgrade({ name = "rabbasca-hellvent-refreshing", quality = event.entity.quality }, inv)
    if e then 
        e.get_inventory(defines.inventory.crafter_trash).transfer_from_inventory(inv) 
        e.set_recipe("rabbasca-contained-imagination-refresh", event.recipe_quality)
    end
    inv.destroy()
end)

script.on_event(prototypes.recipe["rabbasca-contained-imagination-refresh"].on_crafted_event, function(event)
    local inv = game.create_inventory(10)
    local e, _ = event.entity.apply_upgrade({ name = "rabbasca-hellvent", quality = event.entity.quality }, inv)
    if e then e.get_inventory(defines.inventory.crafter_output).transfer_from_inventory(inv) end
    inv.destroy()
end)

-- script.on_event(defines.events.on_player_cancelled_crafting, function(event)
--     game.print("TODO")
-- end)

-- script.on_event(defines.events.on_player_armor_inventory_changed, function(event)
-- end)

-- script.on_event({defines.events.on_equipment_inserted, defines.events.on_equipment_removed}, function(event)
-- end)

if settings.global["rabbasca-debug-mode"].value then
    commands.add_command("rabbasca_ug_sani", nil, function(command)
        local to = tonumber(command.parameter) or 1
        M.set_insanity(to, game.players[command.player_index])
        game.players[command.player_index].print(serpent.line(storage.insanity))
    end)

    -- commands.add_command("rabbasca_ug_imagine", nil, function(command)
    --     M.do_sanity_craft(game.players[command.player_index])
    -- end)
end

return M