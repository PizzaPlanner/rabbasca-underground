local M = { }

function M.try_manifest(source, chance_mult, possible_anomalies)
    if chance_mult <= 0 then return end
    for _, new in pairs(possible_anomalies) do
        local prob_total = new.probability * chance_mult
        if prob_total >= math.random() then
            local p = {
                name = new.name,
                position = source.position,
                quality = source.quality
            }
            if new.type == "resource" then
                local total_amount = (new.richness or 100) * math.random(8, 12) * chance_mult / 100
                local entities = { }
                local tiles = { }
                if total_amount >= 1 then
                    if source.name == "rabbasca-warp-anomaly" then
                        local radius = 3
                        local cx = p.position.x
                        local cy = p.position.y
                        for dx = -radius, radius do
                            for dy = -radius, radius do
                                local pos = { cx + dx, cy + dy }
                                local existing = source.surface.get_tile(pos[1], pos[2])
                                if not (existing.collides_with("out_of_map") or existing.collides_with("harene")) then
                                    local dist = math.sqrt(dx * dx + dy * dy)
                                    if dist <= radius then
                                        table.insert(tiles, {position = pos, name = new.floor})
                                    end
                                end
                            end
                        end
                        table.insert(entities, { name = p.name, position = p.position, quality = p.quality, amount = math.floor(total_amount / 2) })
                        table.insert(entities, { name = p.name, position = { p.position.x + 1, p.position.y }, quality = p.quality, amount = math.floor(total_amount / 8) })
                        table.insert(entities, { name = p.name, position = { p.position.x - 1, p.position.y }, quality = p.quality, amount = math.floor(total_amount / 8) })
                        table.insert(entities, { name = p.name, position = { p.position.x, p.position.y + 1 }, quality = p.quality, amount = math.floor(total_amount / 8) })
                        table.insert(entities, { name = p.name, position = { p.position.x, p.position.y - 1 }, quality = p.quality, amount = math.floor(total_amount / 8) })
                    else
                        local amount_per = math.floor(total_amount / 4)
                        if amount_per >= 1 then
                            for x = p.position.x - 1, p.position.x do
                            for y = p.position.y - 1, p.position.y do
                                table.insert(entities, { name = p.name, position = { x, y }, quality = p.quality, amount = amount_per })
                            end
                            end
                        end
                    end
                end
                source.surface.set_tiles(tiles)
                for _, entry in pairs(entities) do
                    source.surface.create_entity(entry)
                end
            else
                source.surface.set_tiles({{position = p.position, name = "red-desert-0"}})
                source.surface.create_entity(p)
            end

        end
    end
end

function M.replace_entities(surface, config, planet)
    local autoplace = config[planet].autoplace_entities
    local anomalies = config[planet].anomaly_replace_entities
    for _, e in pairs(surface.find_entities_filtered{force = "neutral"}) do
        if e.name == "rabbasca-warp-anomaly" then
            M.try_manifest(e, e.amount, anomalies)
        end
        e.destroy{}
    end
    for _, data in pairs(storage.stabilizer.selfmade_anomalies or { }) do
        M.try_manifest({ position = data.position, quality = "normal", surface = surface }, data.amount * 3, anomalies)
        if data.text then data.text.destroy() end
    end
    storage.stabilizer.selfmade_anomalies = { }
    local map_settings = surface.map_gen_settings
    map_settings.autoplace_settings.entity.settings = autoplace
    map_settings.seed = storage.underground_seed_rng(123456)
    surface.map_gen_settings = map_settings
    surface.regenerate_entity()

    storage.stabilizer.anomalies = { initial = 0, current = 0 }
    local amount_mult = 1 + (game.forces.player.technologies["rabbasca-anomaly-expansion"].level - 1) * 0.1
    for _, e in pairs(surface.find_entities_filtered { name = "rabbasca-warp-anomaly" }) do
        e.amount = e.amount * amount_mult
        storage.stabilizer.anomalies.initial = storage.stabilizer.anomalies.initial + e.amount
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
        if not box_inside(e.bounding_box, safe_zone) then
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