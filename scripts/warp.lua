local M = require("scripts.surface")

local function post_warp_surface(surface)
    surface.daytime = storage.stabilizer.config.planets[storage.stabilizer.current_location].lut_index
    surface.freeze_daytime = true
    surface.min_brightness = 1
    storage.stabilizer.warping = nil
    storage.stabilizer.entity.disabled_by_script = false
    storage.stabilizer.entity.custom_status = nil
    storage.stabilizer.entity.force.chart(surface, {{-72, -72}, {72, 72}})
    if storage.stabilizer.finished_warps == 0 then
        storage.stabilizer.entity.set_recipe(nil)
    else
        storage.stabilizer.entity.set_recipe("rabbasca-warp-trace")
    end
end

function M.on_warp_underground(event)
    if not storage.stabilizer then return end
    local data = storage.stabilizer.warping
    local surface = game.surfaces[storage.stabilizer.surface]
    if not (data and surface and surface.valid) then
        storage.stabilizer.warping = nil -- if surface got removed in between
        return
    end
    if event.tick > data.warp_tick  then
        storage.stabilizer.warping.warp_tick = math.huge
        local config = storage.stabilizer.config
        if not config.planets[data.to] then
            game.print("[ERROR]: Could not warp to "..data.to)
            data.to = M.get_next_planet()
        end
        local last_location = storage.stabilizer.current_location
        storage.stabilizer.current_location = data.to
        storage.stabilizer.safe_zone_setting = storage.stabilizer.safe_zone_setting or 10
        storage.stabilizer.safe_zone_radius = storage.stabilizer.safe_zone_setting
        for _, e in pairs(storage.stabilizer.left_on_warp or { }) do
            if e and e.valid then e.force = "neutral" end
        end
        storage.stabilizer.left_on_warp = { }
        if not storage.stabilizer.flooring.tiles[data.to] then
            M.recalc_tiles()
        end
        if storage.stabilizer.finished_warps then
            M.leave_unsafe(storage.stabilizer.entity)
        end
        if not storage.stabilizer.entity.valid then return end
        M.replace_tiles(surface)
        M.replace_entities(surface, config.planets, data.to)
        surface.regenerate_decorative()
        M.change_affinity(last_location)
        local lut_step = 1 / (3 + 2 * config.planet_count)
        surface.daytime = config.planets[storage.stabilizer.current_location].lut_index - lut_step
        storage.stabilizer.finished_warps = (storage.stabilizer.finished_warps or -1) + 1
    elseif event.tick > data.finished_tick then
        post_warp_surface(surface)
    end
end

function M.get_next_planet()
    local next = storage.stabilizer.next
    if not (next and table_size(next.weights) > 0) then return "rabbasca" end
    local config = storage.stabilizer.config
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
    local config = storage.stabilizer.config
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

function M.change_affinity(last_location)
    local prev = storage.stabilizer.config.planets[last_location]
    if prev then
        local tech = game.forces.player.technologies[prev.tech]
        tech.researched = false
        tech.enabled    = false
    end
    local next = storage.stabilizer.config.planets[storage.stabilizer.current_location]
    if next then
        local tech = game.forces.player.technologies[next.tech]
        tech.researched = true
        tech.enabled    = true
    end
end

function M.get_fuel_time_modifier()
    return (1 + (storage.stabilizer.entity.effects.consumption or 0)) / (storage.stabilizer.entity.crafting_speed)
end

function M.get_warp_cost()
    local weighted_progress = (1 - M.get_repair_progress() * M.get_repair_progress())
    local mod_relics = storage.stabilizer.relics and 1 or 0
    return (0.5 + mod_relics * 0.7 + (12 + mod_relics * 17) * weighted_progress) / M.get_fuel_time_modifier()
end

function M.get_relic_chance()
    return storage.stabilizer.relics and storage.stabilizer.relics.pity or 0
end

function M.hunt_relicary(data)
    if not storage.stabilizer.relics then return end
    if math.random() < M.get_relic_chance() and not data.guaranteed_manifestations then
        data.guaranteed_manifestations = { { type = "poi", name = "rabbasca-relicary", floor = "rabbasca-underground-rubble", force = storage.stabilizer.entity.force } }
        storage.stabilizer.relics = { pity = 0.05 }
    else
        storage.stabilizer.relics = { pity = (storage.stabilizer.relics.pity or 0) + 0.25 * M.get_repair_progress() }
    end
end

function M.warp_to(data)
    if storage.stabilizer.warping then return end
    data = data or { }
    M.hunt_relicary(data)
    data = {
        planet = data.planet or M.get_next_planet(),
        should_recall = data.should_recall or storage.stabilizer.settings.recall,
        fixed_followup = data.fixed_followup or nil,
        guaranteed_manifestations = data.guaranteed_manifestations or { },
    }

    local config = storage.stabilizer.config
    local surface = game.surfaces[storage.stabilizer.surface]
    if not (surface and config.planets[data.planet]) then log("error: stabilizer could not warp to "..data.planet) return end

    storage.stabilizer.warping = { to = data.planet, warp_tick = game.tick + 90, finished_tick = game.tick + 180,
                                   recall = data.should_recall, manifestations = data.guaranteed_manifestations }
    surface.ticks_per_day = 180 * (config.planet_count + 1.5)
    surface.freeze_daytime = false
    for p, _ in pairs(config.planets) do
        if p == data.planet or (data.fixed_followup and p ~= data.fixed_followup) then
            storage.stabilizer.next.weights[p] = 0
        else
            storage.stabilizer.next.weights[p] = ((storage.stabilizer.next.weights[p] or 0) + 1) * 2
        end
    end
    storage.stabilizer.next.seed = storage.underground_seed_rng(10000000)
    storage.stabilizer.entity.disabled_by_script = true
    storage.stabilizer.entity.custom_status = { diode = defines.entity_status_diode.yellow, label = {"", "Warping"} }
end

return M