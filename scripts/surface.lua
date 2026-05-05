local M = { }

function M.get_repair_progress()
    local progress = 1 - storage.stabilizer.anomalies.current / storage.stabilizer.anomalies.initial --(storage.stabilizer.anomalies.trace_inventory.get_item_count("rabbasca-warp-trace")) / (storage.stabilizer.anomalies.initial * 0.075)
    return math.max(0, math.min(1, progress))
end

function M.force_manifest(data, blocked_pois)
    if data.type == "resource" then
        local total_amount = data.amount
        local entities = { }
        local tiles = { }
        if total_amount >= 1 then
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
            blocked_pois[data.name] = true
            for _, player in pairs(storage.stabilizer.entity.force.connected_players) do
                player.add_custom_alert(e, { type = "virtual", name = "signal-map-marker" }, { "rabbasca-extra.alert-found-relicary" }, true)
            end
            return e ~= nil
        end
    end
    return false
end

function M.try_manifest(source, chance_mult, possible_anomalies, existing_pois)
    if chance_mult <= 0 then return end
    for _, new in pairs(possible_anomalies) do
        local prob_total = new.probability * chance_mult
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
            local min = storage.stabilizer.safe_zone_radius or 10
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
        M.try_manifest({ position = data.position, quality = "normal", surface = surface }, data.amount * 3 * progress, anomalies)
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
    local amount_mult = 1 + (game.forces.player.technologies["rabbasca-anomaly-expansion"].level - 1) * 0.1
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
function M.replace_tiles(surface, to, safe_radius)
    storage.stabilizer.tiles = storage.stabilizer.tiles or { }
    storage.stabilizer.last_safe_radius = storage.stabilizer.last_safe_radius or { }
    if not (storage.stabilizer.tiles[to] and storage.stabilizer.last_safe_radius[to] == safe_radius) then
        storage.stabilizer.last_safe_radius[to] = safe_radius
        storage.stabilizer.tiles[to] = { }
        for x = -96, 96 do
        for y = -96, 96 do
            if x*x + y*y <= 96 * 96 then
                local is_safe = math.max(math.abs(x), math.abs(y)) <= safe_radius
                table.insert(storage.stabilizer.tiles[to], { name = is_safe and "rabbasca-underground-rubble-powered" or to, position = { x = x, y = y } })
            end
        end
        end
    end
    surface.set_tiles(storage.stabilizer.tiles[to], true)
end

local function box_inside(a, b)
    return
        a.left_top.x   > b.left_top.x   and
        a.left_top.y   > b.left_top.y   and
        a.right_bottom.x < b.right_bottom.x and
        a.right_bottom.y < b.right_bottom.y
end

function M.recall_outliers(stabilizer, safe_radius)
    local safe_zone = { left_top = { x = -safe_radius - 0.5, y = -safe_radius - 0.5 }, right_bottom = { x = safe_radius + 1.5, y = safe_radius + 1.5 } }
    local to_inventory = (storage.stabilizer.warping.recall and game.create_inventory(512)) or nil
    local saved = 0
    for _, e in pairs(stabilizer.surface.find_entities_filtered { force = stabilizer.force }) do
        if e.valid and not box_inside(e.bounding_box, safe_zone) then
            if to_inventory ~= nil and e.mine { inventory = to_inventory, force = true } then saved = saved + 1 else e.die() end
        end
    end
    if to_inventory then
        Rabbasca.add_to_warp_inventory(to_inventory)
        to_inventory.destroy()
    end
    if saved > 0 then
        for _, player in pairs(game.connected_players) do
            player.create_local_flying_text{ text = { "rabbasca-extra.recall-saved-entities", saved }, position = stabilizer.position, surface = stabilizer.surface, time_to_live = 120 }
        end
    end
end

return M