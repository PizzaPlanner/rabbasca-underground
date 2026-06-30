local M = require("scripts.surface")

local function post_warp_surface(surface)
    local config = storage.stabilizer.config.planets[storage.stabilizer.current_location]
    surface.daytime = config.lut_index
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

local function mask_lights(tick)
local data = storage.stabilizer.warping
if (not data.overlay_mask) and tick < data.finished_tick - 90 then
    -- block any lights that would shine through white lut effect
    storage.stabilizer.warping.overlay_mask = rendering.draw_circle{
        color = {1, 1, 1, 0},
        filled = true,
        radius = 400,
        surface = game.surfaces[storage.stabilizer.surface],
        time_to_live = data.finished_tick - tick + 5,
        target = {0, 0}
    }
    storage.stabilizer.warping.overlay_mask_delta = 2 / (data.finished_tick - tick)
    data = storage.stabilizer.warping
end
local mask = data.overlay_mask
if mask and mask.valid then
    local a = math.max(0, math.min(1, mask.color.a + data.overlay_mask_delta))
    mask.color = {a, a, a, a}
end
return data
end

function M.on_warp_underground(event)
    if not storage.stabilizer then return end
    if not storage.stabilizer.warping then return end
    local surface = game.surfaces[storage.stabilizer.surface]
    if not (surface and surface.valid) then
        storage.stabilizer.warping = nil -- if surface got removed in between
        return
    end
    local data = mask_lights(event.tick)
    if event.tick % 5 > 0 then return end
    if event.tick > data.warp_tick then
        storage.stabilizer.warping.overlay_mask_delta = -storage.stabilizer.warping.overlay_mask_delta
        storage.stabilizer.warping.warp_tick = math.huge
        local config = storage.stabilizer.config
        if not config.planets[data.to] then
            game.print("[ERROR]: Could not warp to "..data.to)
            data.to = M.get_next_planet()
        end
        local last_location = storage.stabilizer.current_location
        storage.stabilizer.current_location = data.to
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
    local techs = storage.stabilizer.entity.force.technologies
    local prev = storage.stabilizer.config.planets[last_location]
    if prev then
        local tech = techs[prev.tech]
        tech.researched = false
        tech.enabled    = false
    else -- fallback only after data change, migrations, etc., touching techs is performance heavy
        for _, planet in storage.stabilizer.config.planets do
            local tech = techs[planet.tech]
            tech.researched = false
            tech.enabled    = false
        end
    end
    local next = storage.stabilizer.config.planets[storage.stabilizer.current_location]
    if next then
        for _, tech in pairs(next.unlock_on_first_arrival or { }) do
            if not techs[tech].researched then
                techs[tech].researched = true
                storage.stabilizer.entity.force.print({ "technology-researched", "[technology="..tech.."]" }, { sound_path = "utility/research_completed" })
            end
        end
        local tech = techs[next.tech]
        tech.researched = true
        tech.enabled    = true
    end
end

function M.get_fuel_time_modifier()
    return (1 + (storage.stabilizer.entity.effects.consumption or 0)) / (storage.stabilizer.entity.crafting_speed)
end

function M.get_relic_chance()
    return storage.stabilizer.relics and storage.stabilizer.relics.pity or 0
end

function M.hunt_relicary(data)
    if not storage.stabilizer.relics then return end
    if math.random() < M.get_relic_chance() and not data.guaranteed_manifestations then
        data.guaranteed_manifestations = { { type = "poi", name = "rabbasca-relicary", floor = "rabbasca-underground-rubble", force = storage.stabilizer.entity.force } }
        storage.stabilizer.relics = { pity = 0 }
    end
end

function M.warp_to(data)
    if storage.stabilizer.warping then return end
    data = data or { }
    M.hunt_relicary(data)
    data = {
        planet = data.planet or M.get_next_planet(),
        fixed_followup = data.fixed_followup or nil,
        guaranteed_manifestations = data.guaranteed_manifestations or { },
    }

    local config = storage.stabilizer.config
    local surface = game.surfaces[storage.stabilizer.surface]
    if not (surface and config.planets[data.planet]) then log("error: stabilizer could not warp to "..data.planet) return end

    storage.stabilizer.warping = { to = data.planet, warp_tick = game.tick + 90, finished_tick = game.tick + 180,
                                   manifestations = data.guaranteed_manifestations }
    surface.ticks_per_day = 180 * (config.planet_count + 1.5)
    surface.freeze_daytime = false
    -- surface.create_entity{
    --     name = "rabbasca-warp-overlay-dummy",
    --     position = {0, 0},
    -- }
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