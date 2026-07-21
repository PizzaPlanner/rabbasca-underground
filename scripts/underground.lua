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

    if storage.stabilizer.warping then
        M.warp.on_warp_underground(event)
        if not storage.stabilizer.entity.valid then return end -- might get destroyed here
    end

    if event.tick % 10 ~= 0 then return end
    M.fuel.update_cells()
    M.warp.update_floorthings()
    M.ui.update_cell_assignment()
    M.ui.update_remote_assignment()

    if event.tick % 60 == 0 then
        M.mining.on_mining_update()
        if storage.stabilizer.anomalies then
            storage.stabilizer.anomalies.current = 0
            for i = #storage.stabilizer.anomalies.entities, 1, -1 do
                local e = storage.stabilizer.anomalies.entities[i]
                if not (e and e.valid) then
                    table.remove(storage.stabilizer.anomalies.entities, i)
                else
                    storage.stabilizer.anomalies.current = storage.stabilizer.anomalies.current + e.amount
                end
            end
            M.update_logistic_section()
            if storage.stabilizer.anomalies.current == 0 and storage.stabilizer.settings.autopilot then
                M.initiate_warp()
            end
        end
        if event.tick % 300 == 0 then
            M.stab.fuel_alert()
        end
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
        storage.stabilizer.current_location = "rabbasca-underground" -- fallback, mainly for logistic section
        game.print("[entity=rabbasca-warp-stabilizer]'s current location was removed from this save, performing emergency warp...")
        M.warp.warp_to()
    end
    if game.surfaces[storage.stabilizer.surface] and not storage.stabilizer.warping then
        M.warp.apply_lighting(game.surfaces[storage.stabilizer.surface])
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
                min = storage.stabilizer.warping and 0 or M.warp.get_repair_progress() * 100,
            },
            {
                value = { name = "rabbasca-warp-anomaly", type = "item", quality = "normal" },
                min = storage.stabilizer.anomalies.current
            },
            {
                value = { name = "rabbasca-stability-pylon", type = "item", quality = "normal" },
                min = M.warp.get_pylon_off_count()
            },
            {
                value = { name = "rabbasca-warp-trace", type = "item", quality = "normal" },
                min = M.stab.get_fuel_percentage() * 100
            },
            {
                value = { name = "rabbasca-powerspike", type = "item", quality = "normal" },
                min = storage.stabilizer.powerspikes.created
            },
            {
                value = { name = "rabbasca-progress-powerspike", type = "item", quality = "normal" },
                min = storage.stabilizer.powerspikes.next
            },
            {
                value = { name = "rabbasca-hunt-relicaries", type = "recipe", quality = "normal" },
                min = M.warp.get_relic_chance() * 100
            },
            {
                value = { name = "rabbasca-hunt-anomalies", type = "recipe", quality = "normal" },
                min = M.warp.get_next_anomaly_richness() * 100
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
        if storage.stabilizer.fuel.inventory then
            storage.stabilizer.fuel.inventory.destroy()
        end
        
        storage.stabilizer = nil
        M.update_logistic_section()

        for _, player in pairs(game.connected_players) do
            M.ui.clear_stabilizer_ui(player)
        end

        local warp_inv = remote.call("rabbasca_warp_inventory", "get")
        if warp_inv then
            local c = warp_inv.get_item_count("rabbasca-collector-pylon")
            if c > 0 then 
                warp_inv.remove({name = "rabbasca-collector-pylon", count = c })
            end
            local s = warp_inv.get_item_count("rabbasca-stability-pylon")
            if s > 0 then
                warp_inv.remove({name = "rabbasca-stability-pylon", count = s })
            end
        end
    end
end

function M.on_progress_floor_anomaly(entity)
    if not storage.stabilizer then return end
    local key = string.format("%i,%i", entity.position.x, entity.position.y)
    if not storage.stabilizer.selfmade_anomalies[key] then
        local text = rendering.draw_text { text =  { "rabbasca-extra.selfmade-anomaly", 0 }, surface = entity.surface, target = entity.position, 
                                           color = { 1, 1, 1 }, alignment = "center", use_rich_text = true, only_in_alt_mode = true }
        storage.stabilizer.selfmade_anomalies[key] = { amount = 0, text = text, position = entity.position }
    end
    local my_anomaly = storage.stabilizer.selfmade_anomalies[key]
    my_anomaly.amount = my_anomaly.amount + 1
    my_anomaly.text.text = { "rabbasca-extra.selfmade-anomaly", my_anomaly.amount }
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
end

function M.on_hunt_relicaries()
    storage.stabilizer.relics = storage.stabilizer.relics or { pity = 0 }
    storage.stabilizer.relics.pity = storage.stabilizer.relics.pity + 0.004
end

function M.download_science(caller, quality)
    if not storage.vault_items then return end
    local inv = caller.get_inventory(defines.inventory.crafter_output)
    if not inv then return end
    if not storage.vault_items["rabbasca-warpfield-science-pack"] then return end
    local count =  storage.vault_items["rabbasca-warpfield-science-pack"][quality] or 0
    if count <= 0 then return end
    local inserted = inv.insert({ name = "rabbasca-warpfield-science-pack", quality = quality, count = math.min(100, count) })
    storage.vault_items["rabbasca-warpfield-science-pack"][quality] = count - inserted
end

function M.upload_science(caller, quality)
    local inv = caller.get_inventory(defines.inventory.crafter_input)
    local count = 10
    if inv then
        local removed = inv.remove({name = "rabbasca-warpfield-science-pack", count = 90, quality = quality})
        count = count + removed
    end
    storage.vault_items = storage.vault_items or { }
    storage.vault_items["rabbasca-warpfield-science-pack"] = storage.vault_items["rabbasca-warpfield-science-pack"] or { }
    storage.vault_items["rabbasca-warpfield-science-pack"][quality] = (storage.vault_items["rabbasca-warpfield-science-pack"][quality] or 0) + count
end

function M.on_locate_progress(vault)
    local surface = game.planets["rabbasca-underground"].surface
    if not surface then
        surface = game.planets["rabbasca-underground"].create_surface()
        M.init_underground(surface)
    end
    local offset = {0, 10}
    local radius = 3 * 32
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

function M.init_underground(surface)
    surface.create_global_electric_network()
    surface.request_to_generate_chunks({0, 0}, 3)
    surface.force_generate_chunk_requests()
    storage.underground_seed_rng = storage.underground_seed_rng or game.create_random_generator(game.default_map_gen_settings.seed + 571681)
    local stab = surface.create_entity {
        name = "rabbasca-warp-stabilizer",
        position = {0, 0},
        force = game.forces.player
    }
    M.stab.register_stabilizer(stab)
end

function M.initiate_warp()
    if not (storage.stabilizer and storage.stabilizer.entity) then return end
    storage.stabilizer.entity.set_recipe("rabbasca-stabilizer-warp-sequence")
end

script.on_event(prototypes.recipe["rabbasca-warpfield-science-pack-wi-download"].on_crafted_event, function(event)
    if event.entity then
        M.download_science(event.entity, event.recipe_quality or "normal")
    end
end)

script.on_event(prototypes.recipe["rabbasca-warpfield-science-pack-wi-upload"].on_crafted_event, function(event)
    if event.entity then
        M.upload_science(event.entity, event.recipe_quality or "normal")
    end
end)

if settings.global["rabbasca-debug-mode"].value then
    commands.add_command("rabbasca_ug_warp", nil, function(command)
        game.print("[DEBUG] [planet=rabbasca-underground] warp initiated")
        local surface = game.surfaces["rabbasca-underground"]
        if not surface then return end
        for _, e in pairs(surface.find_entities_filtered({name = "rabbasca-stability-pylon"})) do
            e.health = math.max(e.health, 20)
        end
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
        M.on_locate_progress()
    end)

    commands.add_command("rabbasca_ug_pp", nil, function(command)
        if storage.stabilizer then M.stab.progress_powerspike(tonumber(command.parameter) or 1) end
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