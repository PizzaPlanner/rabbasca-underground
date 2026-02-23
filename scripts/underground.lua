local M = {
    ui = require("scripts.ui"),
    warp = require("scripts.warp")
}

local function logistics_group_name()
    return tostring(settings.global["rabbasca-underground-logistics-group-name"].value)
end

function M.on_tick_underground(event)
    if not storage.stabilizer then return end
    
    storage.stabilizer.charge.drain = 
          0.00066666667
        + (storage.stabilizer.anomaly_recycler and 0.01 or 0)
        + (storage.stabilizer.warping and 0.3333 * storage.stabilizer.warping.cost or 0)
        + (((storage.stabilizer.safe_zone_radius or 10) - 10) / 4 * 0.005)
        - (storage.stabilizer.progress.charge > event.tick and 0.02 or 0)
    storage.stabilizer.charge.current = math.max(0, storage.stabilizer.charge.current - storage.stabilizer.charge.drain / 60)
    storage.stabilizer.charge.current = math.min(storage.stabilizer.charge.current, storage.stabilizer.charge.max)

    if storage.stabilizer.settings.autopilot == true and storage.stabilizer.anomalies and storage.stabilizer.anomalies.current == 0 then
        M.initiate_warp()
    end

    if event.tick % 120 == 0 then
        local surface = game.surfaces[storage.stabilizer.surface]
        if storage.stabilizer.anomalies then
            local fuel = 0
            for _, e in pairs(surface.find_entities_filtered{ name = "rabbasca-warp-anomaly" }) do
                fuel = fuel + e.amount
            end
            storage.stabilizer.anomalies.current = fuel
            for _, player in pairs(game.connected_players) do
                M.ui.update_affinity_bar(player, true)
            end
            M.update_logistic_section()
        end
        if storage.stabilizer.entity.get_signal({ name = "rabbasca-warp-inventory", type = "virtual" }, defines.wire_connector_id.circuit_green, defines.wire_connector_id.circuit_red) > 0 then
            M.initiate_warp()
        end
    end

    if event.tick % 5 == 0 and storage.stabilizer.warping then
        M.warp.on_warp_underground(event)
    end

    for _, player in pairs(game.connected_players) do
        M.ui.set_stabilizer_ui(player)
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
        next = { weights = { }, seed = 0, blocked_until = 0 },
        settings = {
            autopilot = true,
            recall = false
        },
        config = prototypes.mod_data["rabbasca-stabilizer-config"].data, -- accessing prototypes is expensive, so cache it here too
        charge = { current = 17, max = 20 },
        progress = { repairs = 0, charge = 0 }
    }
    s.get_inventory(defines.inventory.fuel).insert({name = "rabbasca-warp-cell", amount = 37})
    M.warp.warp_to(s.surface, { planet = "aquilo", cost = 0 })
    game.forces.player.chart(s.surface, {{-48, -48}, {48, 48}})
    game.forces.player.print({ "rabbasca-extra.created-underground-stabilizer", s.gps_tag})
end

function M.on_config_changed(handler)
    if not storage.stabilizer then return end
    storage.stabilizer.config = prototypes.mod_data["rabbasca-stabilizer-config"].data -- re-cache in case it changed
    if storage.stabilizer.warping and storage.stabilizer.config.planets[storage.stabilizer.warping.to] == nil then
        storage.stabilizer.warping = nil
        M.warp.warp_to(storage.stabilizer.entity.surface, { cost = 0 })
    elseif not storage.stabilizer.config.planets[storage.stabilizer.current_location] then
        M.warp.warp_to(storage.stabilizer.entity.surface, { cost = 0 })
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
                min = storage.stabilizer.anomalies.current,
            },
            {
                value = { name = "rabbasca-warp-cell", type = "item", quality = "normal" },
                min = math.floor(storage.stabilizer.charge.current * 100)
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
        for _, tech in pairs(storage.stabilizer.config.per_surface_techs) do
            game.forces.player.technologies[tech].researched = false
        end
        storage.stabilizer = nil
        M.update_logistic_section()
    end
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
    if not storage.stabilizer then return end
    storage.stabilizer.progress = {
        repairs = storage.stabilizer.progress.repairs + 1,
        charge  = math.max(storage.stabilizer.progress.charge, game.tick) + 120
    }
end

function M.on_destabilization(entity)
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

function M.reboot_stabilizer(player, value)
    local s = storage.stabilizer and storage.stabilizer.entity
    if not (s and s.valid) then return end
    if (not value) and storage.stabilizer.anomaly_recycler then
        storage.stabilizer.anomaly_recycler.destroy{}
        storage.stabilizer.anomaly_recycler = nil
    elseif value and not storage.stabilizer.anomaly_recycler and storage.stabilizer.charge.current >= 5 then
        storage.stabilizer.anomaly_recycler = s.surface.create_entity {
            name = "rabbasca-stabilizer-consumer",
            position = s.position,
            force = s.force
        }
        storage.stabilizer.charge.current = storage.stabilizer.charge.current - 5
        player.force.technologies["rabbasca-warp-stabilizer"].researched = true
        s.force = player.force
    end
end

function M.on_locate_progress(vault)
    local surface = game.planets["rabbasca-underground"].surface
    if not surface then
        if math.random() > 0.2 then return end
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

function M.initiate_warp(player)
    if not storage.stabilizer then return end
    if game.tick < storage.stabilizer.next.blocked_until then 
        if player then
            player.create_local_flying_text { text = { "rabbasca-extra.warp-on-cooldown" }, surface = storage.stabilizer.surface, position = storage.stabilizer.entity.position }
        end
        return
    end
    M.warp.warp_to(game.surfaces[storage.stabilizer.surface])
end

if settings.global["rabbasca-debug-mode"] then
    commands.add_command("rabbasca_ug_warp", nil, function(command)
        game.print("[DEBUG] [planet=rabbasca-underground] warp initiated")
        local surface = game.surfaces["rabbasca-underground"]
        if not surface then return end
        local to = command.parameter
        if to then
            M.warp.warp_to(surface, { planet = to, cost = 0 })
        else
            M.warp.warp_to(surface, { cost = 0 })
        end
    end)

    commands.add_command("rabbasca_ug_charge", nil, function(command)
        storage.stabilizer.charge.current = tonumber(command.parameter) or storage.stabilizer.charge.current
    end)
end

return M