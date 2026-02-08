local M = require("scripts.ui")

local function stabilizer_config()
    return prototypes.mod_data["rabbasca-stabilizer-config"].data
end

local function logistics_group_name()
    return tostring(settings.global["rabbasca-underground-logistics-group-name"].value)
end

local function on_tick_underground(event)
    if not storage.stabilizer then return end
    local surface = game.surfaces[storage.stabilizer.surface]
    local fuel = 0
    for _, e in pairs(surface.find_entities_filtered{ name = "rabbasca-warp-anomaly" }) do
        fuel = fuel + e.amount
    end
    local numbers = {
        progress = storage.stabilizer.next.required - storage.stabilizer.progress,
        fuel = fuel
    }
    for _, player in pairs(game.connected_players) do
        M.update_affinity_bar(player, numbers)
    end
    M.update_logistic_section(storage.stabilizer.current_location, numbers)
    if storage.stabilizer.progress < storage.stabilizer.next.required then return end
    M.warp_to(surface, M.get_next_planet())
end

local function on_warp_underground(event)
    if not storage.stabilizer then M.register_handlers() return end
    local data = storage.stabilizer.warping
    local surface = game.surfaces[storage.stabilizer.surface]
    if not (data and surface and surface.valid) then
        storage.stabilizer.warping = nil -- if surface got removed in between
         M.register_handlers()
        return
    end
    if event.tick > data.warp_tick  then
        storage.stabilizer.warping.warp_tick = math.huge
        local config = stabilizer_config()
        if not config.planets[data.to] then
            game.print("[ERROR]: Could not warp to "..data.to)
            data.to = M.get_next_planet()
        end
        storage.stabilizer.current_location = data.to
        for _, tag in pairs(storage.stabilizer.resource_tags or {}) do
            tag.destroy{}
        end
        M.replace_tiles(surface, config.water_tiles, config.planets[data.to].water)
        M.replace_entities(surface, config.planets, data.to)
        M.change_affinity()
        local lut_step = 1 / (3 + 2 * config.planet_count)
        surface.daytime = config.planets[storage.stabilizer.current_location].lut_index - lut_step
    elseif event.tick > data.finished_tick then
        M.post_warp_surface(surface)
    end
end

local function register_stabilizer(s)
    if storage.stabilizer and storage.stabilizer.entity ~= s then s.die() return end -- cannot have multiple stabilizers
    local id, _, _ = script.register_on_object_destroyed(s)
    storage.stabilizer = {
        surface = s.surface_index,
        entity = s,
        destroyed_id = id,
        current_location = "rabbasca",
        next = { weights = { }, seed = 0 }
    }
    s.set_recipe("rabbasca-reboot-stabilizer")
    s.get_inventory(defines.inventory.crafter_output).insert({name = "ice", count = 50})
    s.get_inventory(defines.inventory.crafter_trash).insert({name = "ice", count = 450})
    s.get_inventory(defines.inventory.crafter_trash).insert({name = "solid-fuel", count = 500})
    -- s.recipe_locked = true
    -- s.set_fluid(1, { name = "harene", amount = settings.global["rabbasca-underground-starting-fuel"].value })
    M.warp_to(s.surface, "aquilo", "gleba", 5)
    M.register_handlers()
    game.forces.player.chart(s.surface, {{-48, -48}, {48, 48}})
    game.forces.player.print({ "rabbasca-extra.created-underground-stabilizer", s.gps_tag})
end

function M.on_config_changed(handler)
    if not storage.stabilizer then return end
    local config = stabilizer_config()
    if not config.planets[storage.stabilizer.current_location] then
        M.warp_to(storage.stabilizer.entity.surface, M.get_next_planet())
    end
    if storage.stabilizer.warping and config.planets[storage.stabilizer.warping.to] == nil then
        storage.stabilizer.warping = nil
        M.warp_to(storage.stabilizer.entity.surface, M.get_next_planet())
    end
end

-- called in on_load: must adhere to https://lua-api.factorio.com/latest/classes/LuaBootstrap.html#on_load
function M.register_handlers()
    if storage.stabilizer then
        script.on_nth_tick(120, on_tick_underground)
        if storage.stabilizer.warping then
            script.on_nth_tick(5, on_warp_underground)
        end
    end
end

function M.update_logistic_section(planet, numbers)
    local logi = game.forces.player.get_logistic_group(logistics_group_name())
    if not logi then
        game.forces.player.create_logistic_group(logistics_group_name())
        return
    end
    if #logi.members == 0 then return end
    local l = logi.members[1]
    if storage.stabilizer then
        l.filters = {
            {
                value = { name = planet, type = "space-location", quality = "normal" },
                min = numbers.progress,
            },
            {
                value = { name = "rabbasca-warp-matrix", type = "item", quality = "normal" },
                min = numbers.fuel
            }
        }
    else
        l.filters = { }
    end
end

function M.on_stabilizer_died(id)
    if storage.stabilizer and storage.stabilizer.destroyed_id == id then
        game.forces.player.print({ "rabbasca-extra.stabilizer-destroyed" })
        if game.surfaces[storage.stabilizer.surface] and game.surfaces[storage.stabilizer.surface].valid then
            game.delete_surface(storage.stabilizer.surface)
        end
        storage.stabilizer = nil
        M.update_logistic_section()
        for _, tech in pairs(stabilizer_config().per_surface_techs) do
            game.forces.player.technologies[tech].researched = false
        end
        script.on_nth_tick(120, nil)
    end
end

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
                local total_amount = (new.richness or 100) * math.random(0.8, 1.2)
                local entities = { }
                local tiles = { }
                if total_amount > 0 then
                    storage.stabilizer.resource_tags = storage.stabilizer.resource_tags or { }
                    table.insert(storage.stabilizer.resource_tags, game.forces.player.add_chart_tag(source.surface, { position = p.position, text = string.format("[entity=%s]%i // %d%% * %d = %d%% lol", new.name, total_amount, new.probability * 100, chance_mult, prob_total * 100)}))
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
                    end
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
    for _, e in pairs(surface.find_entities_filtered{name = "rabbasca-warp-pylon"}) do
        local recipe = e.get_recipe()
        if recipe and recipe.name == "rabbasca-amplify-anomaly" then
            local amount = e.get_inventory(defines.inventory.crafter_input).get_item_count()
            M.try_manifest(e, amount * 3, anomalies)
        end
    end
    local map_settings = surface.map_gen_settings
    map_settings.autoplace_settings.entity.settings = autoplace
    map_settings.seed = storage.underground_seed_rng(123456)
    surface.map_gen_settings = map_settings
    surface.regenerate_entity()

    -- for _, e in pairs(surface.find_entities_filtered { name = "rabbasca-warp-anomaly" }) do
    --     rendering.draw_animation { 
    --         animation = "rabbasca-warp-anomaly-animation",
    --         surface = e.surface,
    --         target = e,
    --         render_layer = "resource",
    --     }
    -- end

    for _, e in pairs(surface.find_entities_filtered { type = { "offshore-pump", "mining-drill" } }) do
        e.update_connections()
        if e.type == "offshore-pump" then
            local fluid = e.get_fluid_source_fluid()
            e.fluidbox.set_filter(1, fluid and { name = fluid, force = true })
        end
    end
end

-- before: 8 * 233MS ../?? // after: 9 * 133MS ../566 // 17 * 125MS ../120 OR 5*26MS ../73 after reload
function M.replace_tiles(surface, from, to)
    storage.stabilizer.tiles = storage.stabilizer.tiles or { }
    if not storage.stabilizer.tiles[to] then
        storage.stabilizer.tiles[to] = { }
        for _, tile in pairs(surface.find_tiles_filtered {
            has_hidden_tile = true 
        }) do
            for _, f in pairs(from) do
                if tile.hidden_tile == f then
                    table.insert(storage.stabilizer.tiles[to], { name = to, position = tile.position })
                    -- surface.set_hidden_tile(tile.position, to)
                end
            end
        end
        for _, tile in pairs(surface.find_tiles_filtered {
            has_double_hidden_tile = true 
        }) do
            for _, f in pairs(from) do
                if tile.hidden_tile == f then
                    table.insert(storage.stabilizer.tiles[to], { name = to, position = tile.position })
                end
            end
        end
        for _, tile in pairs(surface.find_tiles_filtered {
            name = from
        }) do
            table.insert(storage.stabilizer.tiles[to], { name = to, position = tile.position })
        end
    end
    surface.set_tiles(storage.stabilizer.tiles[to], true)
end

function M.get_next_planet()
    local next = storage.stabilizer.next
    if not next then return "rabbasca" end
    local config = stabilizer_config()
    local total_weight = 0
    for p, w in pairs(next.weights) do
        if config.planets[p] then
            total_weight = total_weight + w
        else
            next.weights[p] = nil -- Planet is no longer available
        end
    end
    local rng = game.create_random_generator(next.seed)
    local number = rng(total_weight)
    for planet, w in pairs(next.weights) do
        number = number - w
        if number <= 0 then
            return planet
        end
    end
    log("Error in get_next_planet: no planet matched rng("..total_weight.."). using fallback")
    return "rabbasca"
end

function M.get_next_planet_chances()
    local next = storage.stabilizer.next
    if not next then return { rabbasca = 1 } end
    local config = stabilizer_config()
    local total_weight = 0
    for p, w in pairs(next.weights) do
        if config.planets[p] then
            total_weight = total_weight + w
        else
            next.weights[p] = nil -- Planet is no longer available
        end
    end
    local chances = { }
    for planet, w in pairs(next.weights) do
        chances[planet] = w / total_weight
    end
    return chances
end

function M.post_warp_surface(surface)
    surface.daytime = stabilizer_config().planets[storage.stabilizer.current_location].lut_index
    surface.freeze_daytime = true
    surface.min_brightness = 1
    storage.stabilizer.warping = nil
end

function M.warp_to(surface, planet, fixed_followup, fixed_stay)
    local config = stabilizer_config()
    storage.stabilizer.progress = 0
    storage.stabilizer.anomaly_progress = 0
    if not (surface and config.planets[planet]) then log("error: stabilizer could not warp to "..planet) return end
    storage.stabilizer.warping = { to = planet, warp_tick = game.tick + 90, finished_tick = game.tick + 180 }
    surface.ticks_per_day = 180 * (config.planet_count + 1.5)
    surface.freeze_daytime = false
    storage.stabilizer.next = storage.stabilizer.next or { seed = 0, weights = { }, required = 0 }
    for p, _ in pairs(config.planets) do
        if p == planet or (fixed_followup and p ~= fixed_followup) then
            storage.stabilizer.next.weights[p] = 0
        else    
            storage.stabilizer.next.weights[p] = ((storage.stabilizer.next.weights[p] or 0) + 1) * 2
        end
    end
    storage.stabilizer.next.seed = storage.underground_seed_rng(10000000)
    storage.stabilizer.next.required = fixed_stay or storage.underground_seed_rng(config.planets[planet].min_stay, config.planets[planet].max_stay) 
    M.register_handlers()
end

function M.abandon(player)
    if storage.stabilizer and storage.stabilizer.entity then
        storage.stabilizer.entity.die(nil, player and player.character)
        if player then
            game.print({ "rabbasca-extra.stabilizer-abandoned", player.name })
        end
    end
end

function M.on_stabilization()
    if storage.stabilizer then
        storage.stabilizer.progress = storage.stabilizer.progress + 1
    end
end

function M.reboot_stabilizer()
    local s = storage.stabilizer and storage.stabilizer.entity
    if not (s and s.valid) then return end
    if s.get_recipe().name == "rabbasca-reboot-stabilizer" then
        -- storage.stabilizer.reboots_left = (storage.stabilizer.reboots_left or 5) - 1
        -- if storage.stabilizer.reboots_left > 0 then return end
        -- storage.stabilizer.reboots_left = nil
        s.force = game.forces.player
        game.forces.player.technologies["rabbasca-warp-stabilizer"].researched = true
        game.forces.player.technologies["rabbasca-warp-floor-expansion"].level = 1
        s.set_recipe("rabbasca-warp-matrix")
        s.surface.create_entity {
        name = "rabbasca-stabilizer-consumer",
        position = s.position,
        force = s.force
    }
    end
    local tiles = { }
    local tile_width = 16 + game.forces.player.technologies["rabbasca-warp-floor-expansion"].level * 4
    for x = -tile_width,tile_width do
    for y = -tile_width,tile_width do
        table.insert(tiles, { position = { x, y }, name = "rabbasca-underground-rubble-powered"})
    end
    end
    s.surface.set_tiles(tiles, true, false)
end

function M.on_locate_progress(vault)
    local surface = game.planets["rabbasca-underground"].surface
    if not surface then
        if math.random() > 0.2 then return end
        game.planets["rabbasca-underground"].create_surface()
        return
    end
    local offset = {0, 10}
    local radius = 3 * 32
    surface.request_to_generate_chunks(offset, 3)
    surface.force_generate_chunk_requests()
    local pos = surface.find_non_colliding_position("rabbasca-warp-pylon", offset, radius, 1)
    if not pos then
        game.forces.player.print({ "rabbasca-extra.created-underground-pylon-error", offset.x, offset.y })
        return
    end
    local spawner = surface.create_entity {
        name = "rabbasca-warp-pylon",
        position = pos,
        force = game.forces.player,
        snap_to_grid = true,
        raise_built = true
    }
    if spawner and vault then
        vault.set_recipe(nil)
    end
end

function M.change_affinity()
    for planet, data in pairs(prototypes.mod_data["rabbasca-stabilizer-config"].data.planets) do
        local researched = planet == storage.stabilizer.current_location
        game.forces.player.technologies[data.tech].researched = researched
        game.forces.player.technologies[data.tech].enabled    = researched
        -- game.forces.player.technologies[data.tech_prep].researched = true
    end
    for _, player in pairs(game.players) do
        M.update_affinity_bar(player)
    end
end

function M.init_underground(surface)
    surface.create_global_electric_network()
    surface.request_to_generate_chunks({0, 0}, 1)
    surface.force_generate_chunk_requests()
    storage.underground_seed_rng = storage.underground_seed_rng or game.create_random_generator(game.default_map_gen_settings.seed + 571681)
    local stab = surface.create_entity {
        name = "rabbasca-warp-stabilizer",
        position = {0, 0},
        force = game.forces.player
    }
    if not stab then game.forces.player.print("[ERROR] Could not create [entity=rabbasca-warp-stabilizer]. This should never happen. Please report a bug.") return end
    register_stabilizer(stab)
end

if settings.global["rabbasca-debug-mode"] then
    commands.add_command("rabbasca_ug_warp", nil, function(command)
    game.print("[DEBUG] [planet=rabbasca-underground] warp initiated")
    local surface = game.surfaces["rabbasca-underground"]
    if not surface then return end
    local to = command.parameter
    if to then
        M.warp_to(surface, to)
    else
        storage.stabilizer.progress = storage.stabilizer.next.required
    end
    end)
end

return M