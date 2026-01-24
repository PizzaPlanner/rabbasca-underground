local M = require("scripts.ui")

function M.max_fuel() return 100000 end

local function stabilizer_config()
    return prototypes.mod_data["rabbasca-stabilizer-config"].data
end

local function logistics_group_name()
    return tostring(settings.global["rabbasca-underground-logistics-group-name"].value)
end

local function on_tick_underground(event)
    if not storage.stabilizer then return end
    local config = stabilizer_config()
    if config.planet_count ~= storage.stabilizer.last_planet_count then
        storage.stabilizer.progress = storage.stabilizer.next.required
        storage.stabilizer.last_planet_count = config.planet_count
    end
    local fluid = storage.stabilizer.entity.get_fluid(1)
    local numbers = {
        progress = storage.stabilizer.next.required - storage.stabilizer.progress,
        fuel = (fluid and fluid.amount / M.max_fuel()) or 0
    }
    for _, player in pairs(game.connected_players) do
        M.update_affinity_bar(player, numbers)
    end
    M.update_logistic_section(storage.stabilizer.current_location, numbers)
    if storage.stabilizer.progress < storage.stabilizer.next.required then return end
    M.warp_to(game.surfaces[storage.stabilizer.surface], M.get_next_planet())
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
            data.to = storage.stabilizer.current_location
        end
        storage.stabilizer.current_location = data.to
        M.replace_tiles(surface, config.water_tiles, config.planets[data.to].water)
        M.replace_entities(surface, config.planets[data.to].autoplace_entities, data.to)
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
        seeds = { },
        current_location = "rabbasca",
        last_planet_count = stabilizer_config().planet_count,
        next = { weights = { }, seed = 0 }
    }
    s.set_recipe("rabbasca-reboot-stabilizer")
    s.recipe_locked = true
    s.set_fluid(1, { name = "harene", amount = settings.global["rabbasca-underground-starting-fuel"].value })
    M.warp_to(s.surface, "rabbasca")
    M.register_handlers()
    game.forces.player.chart(s.surface, {{-48, -48}, {48, 48}})
    game.forces.player.print({ "rabbasca-extra.created-underground-stabilizer", s.gps_tag})
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
                value = { name = "harene", type = "fluid", quality = "normal" },
                min = numbers.fuel * M.max_fuel()
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
        script.on_nth_tick(120, nil)
    end
end

function M.replace_entities(surface, settings, planet)
    for _, e in pairs(game.surfaces["rabbasca-underground"].find_entities_filtered{force = "neutral"}) do e.destroy{} end
    storage.stabilizer.seeds[planet] = storage.stabilizer.seeds[planet] or storage.underground_seed_rng(123456)
    local map_settings = surface.map_gen_settings
    map_settings.autoplace_settings.entity.settings = settings
    map_settings.seed = storage.stabilizer.seeds[planet]
    surface.map_gen_settings = map_settings
    surface.regenerate_entity()

    for _, e in pairs(surface.find_entities_filtered { type = { "offshore-pump", "mining-drill" } }) do
        e.update_connections()
        if e.type == "offshore-pump" then
            local fluid = e.get_fluid_source_fluid()
            e.fluidbox.set_filter(1, fluid and { name = fluid, force = true })
        end
    end
end

function M.replace_tiles(surface, from, to)
    for _, tile in pairs(surface.find_tiles_filtered {
        has_hidden_tile = true 
    }) do
        for _, f in pairs(from) do
            if tile.hidden_tile == f then
                surface.set_hidden_tile(tile.position, to)
            end
        end
    end
    for _, tile in pairs(surface.find_tiles_filtered {
        has_double_hidden_tile = true 
    }) do
        for _, f in pairs(from) do
            if tile.hidden_tile == f then
                surface.set_double_hidden_tile(tile.position, to)
            end
        end
    end
    local tiles = { }
    for _, tile in pairs(surface.find_tiles_filtered {
        name = from
    }) do
        table.insert(tiles, { name = to, position = tile.position })
    end
    surface.set_tiles(tiles, true)
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

function M.warp_to(surface, planet)
    local config = stabilizer_config()
    storage.stabilizer.progress = 0
    if not (surface and config.planets[planet]) then log("error: stabilizer could not warp to "..planet) return end
    storage.stabilizer.warping = { to = planet, warp_tick = game.tick + 90, finished_tick = game.tick + 180 }
    surface.ticks_per_day = 180 * (config.planet_count + 1.5)
    surface.freeze_daytime = false
    storage.stabilizer.next = storage.stabilizer.next or { seed = 0, weights = { }, required = 0 }
    for p, _ in pairs(config.planets) do
        if p == planet then
            storage.stabilizer.next.weights[p] = 0
        else    
            storage.stabilizer.next.weights[p] = ((storage.stabilizer.next.weights[p] or 0) + 1) * 2
        end
    end
    storage.stabilizer.next.seed = storage.underground_seed_rng(10000000)
    storage.stabilizer.next.required = storage.underground_seed_rng(config.planets[planet].min_stay, config.planets[planet].max_stay) 
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

function M.reboot_stabilizer(s)
    s.force = game.forces.player
    game.forces.player.technologies["rabbasca-warp-stabilizer"].researched = true
    s.set_recipe("rabbasca-warp-matrix")
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
    local tiles = {
        { position = {pos.x- 1, pos.y- 1}, name = "rabbasca-energetic-concrete" },
        { position = {pos.x+ 0, pos.y- 1}, name = "rabbasca-energetic-concrete" },
        { position = {pos.x- 1, pos.y+ 0}, name = "rabbasca-energetic-concrete" },
        { position = {pos.x+ 0, pos.y+ 0}, name = "rabbasca-energetic-concrete" },
    }
    surface.set_tiles(tiles)
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
        game.forces.player.technologies[data.tech_prep].researched = true
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
    surface.create_entity {
        name = "rabbasca-stabilizer-consumer",
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