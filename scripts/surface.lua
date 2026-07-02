local M = { }

function M.get_next_anomaly_richness()
    return 1 + (storage.stabilizer.extra_anomalies or 0)
end

function M.get_repair_progress()
    local progress = 1 - storage.stabilizer.anomalies.current / storage.stabilizer.anomalies.initial
    return math.max(0, math.min(1, progress))
end

function M.force_manifest(data, blocked_pois)
    if data.type == "resource" then
        local total_amount = data.amount
        local entities = { }
        local tiles = { }
        if total_amount >= 8 then
            if data.floor then
                local radius = 3
                local cx = data.position.x
                local cy = data.position.y
                for dx = -radius, radius do
                    for dy = -radius, radius do
                        local pos = { cx + dx, cy + dy }
                        local existing = data.surface.get_tile(pos[1], pos[2])
                        if not (existing.collides_with("out_of_map") or existing.collides_with("harene")) then
                            local dist = math.sqrt(dx * dx + dy * dy)
                            if dist <= radius then
                                table.insert(tiles, {position = pos, name = data.floor})
                            end
                        end
                    end
                end
                table.insert(entities, { name = data.name, position = data.position, quality = data.quality, amount = math.floor(total_amount / 2) })
                table.insert(entities, { name = data.name, position = { data.position.x + 1, data.position.y }, quality = data.quality, amount = math.floor(total_amount / 8) })
                table.insert(entities, { name = data.name, position = { data.position.x - 1, data.position.y }, quality = data.quality, amount = math.floor(total_amount / 8) })
                table.insert(entities, { name = data.name, position = { data.position.x, data.position.y + 1 }, quality = data.quality, amount = math.floor(total_amount / 8) })
                table.insert(entities, { name = data.name, position = { data.position.x, data.position.y - 1 }, quality = data.quality, amount = math.floor(total_amount / 8) })
            else
                local amount_per = math.floor(total_amount / 4)
                if amount_per >= 1 then
                    for x = data.position.x - 1, data.position.x do
                    for y = data.position.y - 1, data.position.y do
                        table.insert(entities, { name = data.name, position = { x, y }, quality = data.quality, amount = amount_per })
                    end
                    end
                end
            end
        end
        data.surface.set_tiles(tiles)
        local count = 0
        for _, entry in pairs(entities) do
            if data.surface.create_entity(entry) then count = count + 1 end
        end
        if count > 0 then
            storage.stabilizer.entity.force.set_script_visible({ type = "entity", name = data.name }, true)
        end
        return count > 0
    elseif data.type == "poi" and blocked_pois and blocked_pois[data.name] == nil then
        local tiles = { }
        local radius = 2
        local cx = data.position.x
        local cy = data.position.y
        if not data.surface.get_tile(cx, cy).collides_with("harene") then
            for dx = -radius, radius do
                for dy = -radius, radius do
                    local pos = { cx + dx, cy + dy }
                    local existing = data.surface.get_tile(pos[1], pos[2])
                    if not (existing.collides_with("out_of_map") or existing.collides_with("harene")) then
                        -- local dist = math.sqrt(dx * dx + dy * dy)
                        -- if dist <= radius then
                            table.insert(tiles, {position = pos, name = data.floor})
                        -- end
                    end
                end
            end
            data.surface.set_tiles(tiles)
            local e = data.surface.create_entity({ name = data.name, position = data.position, force = data.force })
            if e == nil then return false end
            storage.stabilizer.entity.force.set_script_visible({ type = "entity", name = data.name }, true)
            blocked_pois[data.name] = true
            
            if e.name == "rabbasca-relicary" then
                storage.stabilizer.left_on_warp = storage.stabilizer.left_on_warp or { }
                table.insert(storage.stabilizer.left_on_warp, e)
                for _, access in pairs(data.surface.find_entities_filtered { name = "rabbasca-relicary-remote" }) do
                    access.proxy_target_entity = e
                end
                for _, player in pairs(storage.stabilizer.entity.force.connected_players) do
                    player.add_custom_alert(e, { type = "recipe", name = "rabbasca-hunt-relicaries" }, { "rabbasca-extra.alert-found-relicary" }, true)
                end
            end

            return true
        end
    end
    return false
end

function M.try_manifest(source, chance_mult, possible_anomalies, existing_pois)
    if chance_mult <= 0 then return end
    for _, new in pairs(possible_anomalies) do
        local prob_total = (new.probability or 0) * chance_mult
        for _, player in pairs(game.players) do
            player.create_local_flying_text { text = { "", string.format("Chance for manifestation: %.2f%%", prob_total * 100) }, surface = source.surface, position = source.position }
        end
        if prob_total >= math.random() then
            local p = {
                name = new.name,
                amount = (new.richness or 100) * math.random(8, 12) * chance_mult / 100,
                position = source.position,
                quality = source.quality,
                surface = source.surface,
                type = new.type,
                force = source.force,
                floor = new.floor
            }
            if M.force_manifest(p, existing_pois) then return end
            
        end
    end
end

function M.replace_entities(surface, config, planet)
    local autoplace = config[planet].autoplace_entities
    local anomalies = config[planet].anomaly_replace_entities
    local progress  = M.get_repair_progress()
    local pois      = { }
    for _, e in pairs(surface.find_entities_filtered{force = "neutral"}) do
        if e.name == "rabbasca-warp-anomaly" then
            M.try_manifest(e, e.amount * progress, anomalies, pois)
        end
        e.destroy{}
    end
    for _, guaranteed in pairs(storage.stabilizer.warping.manifestations) do
        local success = 0
        while success < 50 do
            local min = 10
            guaranteed.position = guaranteed.position or { x = math.random(min, min + 64), y = math.random(min, min + 64) }
            guaranteed.surface  = surface
            guaranteed.quality  = guaranteed.quality or "normal"
            guaranteed.force    = guaranteed.force or "neutral"
            guaranteed.amount   = guaranteed.amount or (guaranteed.richness or 100) * math.random(8, 12)
            success = M.force_manifest(guaranteed, pois) and 100 or (success + 1)
            guaranteed.position = nil
        end
        if success < 100 then 
            game.print("[color=red][Error][space-location=rabbasca-warp-stabilizer-site] Could not generate guaranteed POI '"..guaranteed.name.."'. Please report a bug to the mod author![/color]") 
        end
    end
    for _, data in pairs(storage.stabilizer.selfmade_anomalies or { }) do
        M.try_manifest({ position = data.position, quality = "normal", surface = surface }, data.amount * progress, anomalies)
        if data.text then data.text.destroy() end
    end
    storage.stabilizer.selfmade_anomalies = { }
    local map_settings = surface.map_gen_settings
    map_settings.autoplace_settings.entity.settings = autoplace
    map_settings.seed = storage.underground_seed_rng(123456)
    surface.map_gen_settings = map_settings
    surface.regenerate_entity()

    storage.stabilizer.anomalies.initial = 0
    storage.stabilizer.anomalies.entities = { }
    local amount_mult = M.get_next_anomaly_richness()
    storage.stabilizer.extra_anomalies = 0
    for _, e in pairs(surface.find_entities_filtered { name = "rabbasca-warp-anomaly" }) do
        e.amount = e.amount * amount_mult
        storage.stabilizer.anomalies.initial = storage.stabilizer.anomalies.initial + e.amount
        table.insert(storage.stabilizer.anomalies.entities, e)
    end

    for _, e in pairs(surface.find_entities_filtered { type = { "offshore-pump", "mining-drill" } }) do
        e.update_connections()
        if e.type == "offshore-pump" then
            local fluid = e.get_fluid_source_fluid()
            e.fluidbox.set_filter(1, fluid and { name = fluid, force = true })
        end
    end
end

-- before: 8 * 233MS ../?? // after: 9 * 133MS ../566 // 17 * 125MS ../120 OR 5*26MS ../73 after reload
function M.replace_tiles(surface)
    local planet = storage.stabilizer.warping.to
    surface.set_tiles(storage.stabilizer.flooring.tiles[planet], true)
    local flooring_left = { }
    for _, t in pairs(surface.find_tiles_filtered({name = "rabbasca-underground-rubble"})) do
        table.insert(flooring_left, { name = "rabbasca-underground-out-of-map", position = t.position })
    end
    surface.set_tiles(flooring_left, true)

end

function M.is_box_safe(b)
    for x = b.left_top.x, b.right_bottom.x do
    for y = b.left_top.y, b.right_bottom.y do
        if not storage.stabilizer.flooring.safe_tiles[math.floor(x) + math.floor(y) * 1000] then 
            return false
        end
    end
    end
    return true
end

function M.leave_unsafe(stabilizer)
    local surface = stabilizer.surface
    for _, e in pairs(surface.find_entities_filtered { force = stabilizer.force }) do
        if e.valid and not M.is_box_safe(e.bounding_box) then
            e.die()
        end
    end
end

function M.is_tile_safe(pos)
    local t = storage.stabilizer.flooring.safe_tiles[pos.x + pos.y * 1000]
    if not t then return end
    for _, e in pairs(t) do
        if e then return true end
    end
    return false
end

function M.add_safe_tile(pos, reason)
    if not storage.stabilizer.flooring.safe_tiles[pos.x + pos.y * 1000] then
        storage.stabilizer.flooring.safe_tiles[pos.x + pos.y * 1000] = { }
    end
    storage.stabilizer.flooring.safe_tiles[pos.x + pos.y * 1000][reason] = true
end

function M.remove_safe_tile(pos, reason)
    if not storage.stabilizer.flooring.safe_tiles[pos.x + pos.y * 1000] then return end
    storage.stabilizer.flooring.safe_tiles[pos.x + pos.y * 1000][reason] = nil
    if not M.is_tile_safe(pos) then 
        storage.stabilizer.flooring.safe_tiles[pos.x + pos.y * 1000] = nil 
    end
end

local function swap_floor(e, on)
    if not storage.stabilizer then return end
    local origin = e.position or { x = e.x, y = e.y }
    local tiles = { }
    for x = -6, 5 do
        for y = -6, 5 do
            local pos = {x = x + origin.x, y = y + origin.y } 
            local to  = (on or M.is_tile_safe(pos)) and "rabbasca-underground-rubble-powered" or "rabbasca-underground-rubble"
            table.insert(tiles, { name = to, position = pos })
        end
    end
    e.surface.set_tiles(tiles)
end

function M.remove_floorthing(pos, id)
    for x = -6, 5 do
        for y = -6, 5 do
            local p = {x = x + pos.x, y = y + pos.y }
            M.remove_safe_tile(p, id)
        end
    end
    swap_floor({ position = pos, surface = storage.stabilizer.entity.surface }, false)
end

function M.add_floorthing(pos, id)
    for x = -6, 5 do
        for y = -6, 5 do
            local p = {x = x + pos.x, y = y + pos.y } 
            M.add_safe_tile(p, id)
        end
    end
    swap_floor({ position = pos, surface = storage.stabilizer.entity.surface }, false)
end

function M.recalc_tiles()
    storage.stabilizer.flooring = storage.stabilizer.flooring or {
        entities = { },
        tiles = { },
        safe_tiles = { },
    }
    storage.stabilizer.flooring.safe_tiles = storage.stabilizer.flooring.safe_tiles or { }

    for planet, _ in pairs(storage.stabilizer.config.planets) do
        storage.stabilizer.flooring.tiles[planet] = { }
    end

    for x = -96, 96 do
    for y = -96, 96 do
        if x*x + y*y <= 96 * 96 then
            local pos = { x = x, y = y }
            local is_safe = storage.stabilizer.flooring.safe_tiles[pos.x + pos.y * 1000] ~= nil
            for planet, pdata in pairs(storage.stabilizer.config.planets) do
                table.insert(storage.stabilizer.flooring.tiles[planet], { name = is_safe and "rabbasca-underground-rubble-powered" or pdata.water, position = { x = x, y = y } })
            end
        end
    end
    end
end

function M.relocate_floorthing(e)
    if not (storage.stabilizer and e.valid) then return end
    for _, ghost in pairs(e.surface.find_entities_filtered { name = "entity-ghost", ghost_name = e.name }) do
        local current = e.position
        local new = ghost.position
        ghost.destroy{ }
        if e.teleport(new) then
            storage.stabilizer.flooring.dirty = true
        end
        return
    end
end

function M.update_floorthings()
    for id, e in pairs(storage.stabilizer.flooring.entities) do
        if not e.entity.valid then return end
        local new_on = e.entity.health > 10
        if new_on ~= e.on then
            if e.on == nil then
                e.entity.health = 5 -- cant set this as placement trigger response for some reason
            end
            storage.stabilizer.flooring.dirty = true
            e.on = new_on
            if new_on then
                M.add_floorthing(e.position, id)
            else
                M.remove_floorthing(e.position, id)
            end
        end
        e.entity.health = math.max(1, e.entity.health)
    end
end

function M.register_floorthing(e)
    local id, _, _ = script.register_on_object_destroyed(e)
    if storage.stabilizer.flooring.entities[id] then return end
    storage.stabilizer.flooring.entities[id] = {
        entity = e,
        position = e.position,
        on = nil
    }
    e.set_recipe("rabbasca-floor-stability-work")
end

function M.on_floorthing_died(id)
    if not (storage.stabilizer and storage.stabilizer.flooring) then return end
    if not storage.stabilizer.flooring.entities[id] then return end
    local pos = storage.stabilizer.flooring.entities[id].position
    M.remove_floorthing(pos, id)
    storage.stabilizer.flooring.entities[id] = nil
    storage.stabilizer.flooring.dirty = true
end

return M