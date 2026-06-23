local M = {
    ui = require("scripts.ui"),
    warp = require("scripts.warp"),
    fuel = require("scripts.fuel"),
    mining = require("scripts.mining"),
    stab = require("scripts.stabilizer"),
}

local function logistics_group_name()
    return tostring(settings.global["rabbasca-underground-logistics-group-name"].value)
end

function M.on_tick_underground(event)
    if not storage.stabilizer then return end
    if not storage.stabilizer.entity.valid then return end

    M.stab.update_crafting()
    M.stab.trace_stasis()
    
    for _, player in pairs(game.connected_players) do
        M.ui.set_stabilizer_ui(player)
    end
    
    -- M.fuel.recharge_consumers()
    M.fuel.update_cells()

    if event.tick % 10 ~= 0 then return end
    M.warp.update_floorthings()
    M.ui.update_cell_assignment()

    if event.tick % 60 == 0 then
        M.mining.on_mining_update()
        if storage.stabilizer.anomalies then
            storage.stabilizer.anomalies.current = 0
            for _, e in pairs(storage.stabilizer.anomalies.entities) do
                if e.valid then
                    storage.stabilizer.anomalies.current = storage.stabilizer.anomalies.current + e.amount
                end
            end
            M.update_logistic_section()
            if storage.stabilizer.anomalies.current == 0 and storage.stabilizer.settings.autopilot then
                M.initiate_warp()
            end
        end
    end
    
    if storage.stabilizer.warping then
        M.warp.on_warp_underground(event)
    end
end

function M.on_config_changed(handler)
    if not storage.stabilizer then return end
    storage.stabilizer.config = prototypes.mod_data["rabbasca-stabilizer-config"].data -- re-cache in case it changed
    M.warp.recalc_tiles()
    if storage.stabilizer.warping and storage.stabilizer.config.planets[storage.stabilizer.warping.to] == nil then
        storage.stabilizer.warping = nil
        M.warp.warp_to()
    elseif not storage.stabilizer.config.planets[storage.stabilizer.current_location] then
        M.warp.warp_to()
    end
end

function M.update_logistic_section()
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
                value = { name = storage.stabilizer.current_location, type = "space-location", quality = "normal" },
                min = M.warp.get_repair_progress() * 100,
            },
            {
                value = { name = "rabbasca-warp-anomaly", type = "entity", quality = "normal" },
                min = storage.stabilizer.anomalies.current
            }
        }
    else
        l.filters = { }
    end
end

function M.on_stabilizer_died(id)
    if storage.stabilizer and storage.stabilizer.destroyed_id == id then
        if not M.warp.is_box_safe({left_top = {x = -4, y = -4}, right_bottom = {x = 4, y = 4} }) then
            game.forces.player.print({ "rabbasca-extra.stabilizer-destroyed-reason-floor" })
        else
            game.forces.player.print({ "rabbasca-extra.stabilizer-destroyed" })
        end
        if game.surfaces[storage.stabilizer.surface] and game.surfaces[storage.stabilizer.surface].valid then
            game.delete_surface(storage.stabilizer.surface)
        end
        for _, tech in pairs(storage.stabilizer.config.per_surface_techs) do
            game.forces.player.technologies[tech].researched = false
            -- game.forces.player.technologies[tech].enabled    = false
        end
        storage.stabilizer = nil
        M.update_logistic_section()

        for _, player in pairs(game.connected_players) do
            M.ui.clear_stabilizer_ui(player)
        end
    end
end

function M.summon_fleet(surface, position)
    if not storage.stabilizer then return end
    local fuel_cost = prototypes.entity["rabbasca-ufo"].burner_prototype.initial_fuel.fuel_value / 2
    for _, c in pairs(storage.stabilizer.fuel.consumers) do
        local e = c.entity
        if e.valid and e.name == "rabbasca-ufo" then
            if e.burner.remaining_burning_fuel > fuel_cost then
                e.burner.remaining_burning_fuel = e.burner.remaining_burning_fuel - fuel_cost
                local p = { x = position.x + math.random(-3, 3), y = position.y + math.random(-3, 3) }
                e.teleport(p, surface, false)
            end
        end
    end
end

function M.on_hunt_anomalies()
    storage.stabilizer.extra_anomalies = (storage.stabilizer.extra_anomalies or 0) + 0.03
    game.print("[entity=rabbasca-warp-anomaly] mult = "..(1 + storage.stabilizer.extra_anomalies))
end

function M.on_hunt_relicaries()
    storage.stabilizer.relics = storage.stabilizer.relics or { pity = 0 }
    storage.stabilizer.relics.pity = storage.stabilizer.relics.pity + 0.004
    game.print("[entity=rabbasca-relicary] chance = "..storage.stabilizer.relics.pity)
end

function M.download_science(caller)
    local from = remote.call("rabbasca_warp_inventory", "get")
    if not from then return end
    local to = caller.get_inventory(defines.inventory.crafter_trash)
    if not to then return end
    local downloaded = from.remove({name = "rabbasca-warpfield-science-pack", count = 200})
    if downloaded <= 0 then return end
    local remaining = downloaded - to.insert({ name = "rabbasca-warpfield-science-pack", count = downloaded})
    if remaining > 0 then
        from.insert({name = "rabbasca-warpfield-science-pack", count = remaining})
    end
end

function M.on_locate_progress(vault)
    local surface = game.planets["rabbasca-underground"].surface
    if not surface then
        if math.random() > 0.2 then 
            if vault then vault.get_inventory(defines.inventory.crafter_input).insert({name = "rabbasca-warp-pylon", count = 1}) end
            return
        end
        surface = game.planets["rabbasca-underground"].create_surface()
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
    M.init_underground(surface)
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
    M.stab.register_stabilizer(stab)
end

function M.initiate_warp()
    if not (storage.stabilizer and storage.stabilizer.entity) then return end
    storage.stabilizer.entity.set_recipe("rabbasca-stabilizer-warp-sequence")
end

if settings.global["rabbasca-debug-mode"] then
    commands.add_command("rabbasca_ug_warp", nil, function(command)
        game.print("[DEBUG] [planet=rabbasca-underground] warp initiated")
        local surface = game.surfaces["rabbasca-underground"]
        if not surface then return end
        local to = command.parameter
        if to then
            M.warp.warp_to({ planet = to })
        else
            M.warp.warp_to()
        end
    end)

    commands.add_command("rabbasca_ug_bye", nil, function(command)
        M.stab.abandon(command.player_index and game.get_player(command.player_index))
    end)

    commands.add_command("rabbasca_ug_hey", nil, function(command)
        surface = game.planets["rabbasca-underground"].create_surface()
        M.on_locate_progress()
    end)

    commands.add_command("rabbasca_ug_repair", nil, function(command)
        local percent = tonumber(command.parameter) or 1
        local anoms = storage.stabilizer.entity.surface.find_entities_filtered { name = "rabbasca-warp-anomaly" }
        local per_anom = storage.stabilizer.anomalies.initial * (1 - percent) / #anoms
        for _, e in pairs(anoms) do
            if per_anom > 0 then
                e.amount = per_anom
            else
                e.destroy { }
            end
        end
    end)
end

return M