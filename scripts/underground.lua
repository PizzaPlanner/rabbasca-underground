local M = {
    ui = require("scripts.ui"),
    warp = require("scripts.warp"),
    fuel = require("scripts.fuel"),
    mining = require("scripts.mining")
}

local function logistics_group_name()
    return tostring(settings.global["rabbasca-underground-logistics-group-name"].value)
end

local function craft_without_fuel(e)
    -- local recipe = e.get_recipe()
    -- if (#recipe.ingredients > 0 and not e.is_crafting()) then return end
    e.energy = 10000000
end

local function update_crafting()
    local recipe = storage.stabilizer.entity.get_recipe()
    if not recipe then return end
    recipe = recipe.name
    if recipe == "rabbasca-warp-trace" and not storage.stabilizer.entity.is_crafting() then
        local inv_in  = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_input)
        local inv_out = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_trash)
        local missing = 50 - inv_in.get_item_count("rabbasca-warp-anomaly")
        if missing > 0 and inv_out.get_item_count("rabbasca-warp-anomaly") >= missing then
            inv_in.insert({name = "rabbasca-warp-anomaly", count = inv_out.remove({name = "rabbasca-warp-anomaly", count = missing})})
        end
    elseif recipe == "rabbasca-stabilizer-warp-sequence" and not M.warp.is_box_safe({left_top = { x = -4, y = -4 }, right_bottom = { x = 4, y = 4 }}) then
        storage.stabilizer.entity.crafting_progress = 0
        if game.tick % 180 == 0 then
            for _, player in pairs(storage.stabilizer.entity.force.players) do
                player.create_local_flying_text { text = {"rabbasca-extra.warp-paused-not-safe" }, surface = storage.stabilizer.entity.surface, position = storage.stabilizer.entity.position }
            end
        end
    elseif recipe == "rabbasca-abandon-stabilizer" then
        for _, player in pairs(storage.stabilizer.entity.force.players) do
            player.add_custom_alert(storage.stabilizer.entity, { type = "entity", name = "rabbasca-warp-stabilizer" }, { "rabbasca-extra.alert-abandon" }, true)
        end
    elseif recipe == "rabbasca-emergency-fuel" then
        craft_without_fuel(storage.stabilizer.entity)
    end
end

local function update_trash()
    local trash_inv = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_trash)
    local saved = trash_inv.find_item_stack("rabbasca-warp-trace")
    local missing = math.min(1, 250 - (saved and saved.valid_for_read and saved.count or 0))

    local traces = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_output).find_item_stack("rabbasca-warp-trace")
    if traces ~= nil and missing > 0 then 
        traces.count = traces.count - trash_inv.insert({ name = "rabbasca-warp-trace", count = math.min(missing, math.max(1, math.floor(traces.count / 100)))})
    end
    if not saved then return end
    if storage.stabilizer.warping ~= nil then return end
    saved.spoil_percent = 0
end

local function update_remote_assignment()
    if not storage.assign_remote then return end
    for player, data in pairs(storage.assign_remote) do
        local p = game.get_player(player)
        if not (p and data.chest and data.chest.valid and p.surface == data.chest.surface) then 
            storage.assign_remote[player] = nil
            return
        end
        local pos = data.chest.position
        rendering.draw_rectangle({
            color = {0, 0.07, 0.25, 0.01},
            filled = true,
            left_top = { x = pos.x - 10, y = pos.y - 10 },
            right_bottom = { x = pos.x + 10, y = pos.y + 10 },
            surface = data.chest.surface,
            time_to_live = 1,
            players = { player }
        })
        if p.opened then
            if p.opened == data.selected then 
                data.chest.proxy_target_entity = data.selected
                p.opened = data.chest
                game.print("Deal!")
            end
            game.print("Connection end")
            storage.assign_remote[player] = nil
        elseif p.selected and (
            p.selected.type == "assembling-machine" 
         or p.selected.type == "furnace" 
         or p.selected.type == "container" 
         or p.selected.type == "logistics-container"
         or p.selected.type == "spider-vehicle") then
            local is_in_range = math.abs(data.chest.position.x - p.selected.position.x) < 10 and math.abs(data.chest.position.y - p.selected.position.y) < 10
            if is_in_range then
                data.selected = p.selected
            end
            rendering.draw_line({
                surface = data.chest.surface, 
                players = { player }, 
                time_to_live = 1, 
                from = data.chest, to = p.selected, 
                color = { 0, 0, 0 }, 
                width = 5, gap_length = 0.25, dash_length = 0.75})
            rendering.draw_line({
                surface = data.chest.surface, 
                players = { player }, 
                time_to_live = 1, 
                from = data.chest, to = p.selected, 
                color = is_in_range and {1, 1, 1} or { 1, 0, 0 }, 
                width = 3, gap_length = 0.3, dash_length = 0.7, dash_offset = 0.025})
        end
    end
    if table_size(storage.assign_remote) == 0 then storage.assign_remote = nil end
end

function M.on_tick_underground(event)
    update_remote_assignment()
    if not storage.stabilizer then return end
    if not storage.stabilizer.entity.valid then return end

    update_crafting()
    update_trash()
    M.mining.on_mining_update()

    for _, player in pairs(game.connected_players) do
        M.ui.set_stabilizer_ui(player)
    end

    -- M.fuel.set_fueller_target()
    -- M.fuel.recharge_consumers()
    if event.tick % 3 == 0 then
        M.fuel.recharge_consumers_alt()
    end

    if event.tick % 10 ~= 0 then return end
    M.warp.update_floorthings()

    if event.tick % 60 == 0 then
        for _, player in pairs(game.connected_players) do
            M.ui.set_fuel_remote_ui(player)
        end
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

local function register_stabilizer(s)
    if storage.stabilizer and storage.stabilizer.entity ~= s then s.die() return end -- cannot have multiple stabilizers
    local id, _, _ = script.register_on_object_destroyed(s)
    storage.stabilizer = {
        surface = s.surface_index,
        entity = s,
        destroyed_id = id,
        current_location = "rabbasca",
        next = { weights = { }, seed = 0 },
        settings = {
            autopilot = true,
        },
        relics = { pity = 0 },
        fuel = { recharger = nil, consumers = { }, selector = { index = 0, unfiltered_index = 0, filter = { }, full = false, read_from_network = false } },
        miners = { available = 1, active_target = 0, entities = { }, last_deployment = 0 },
        powerspikes = 0,
        flooring = {
            entities = { },
            tiles = { },
            safe_tiles = { }
        },
        anomalies = { initial = 0, current = 0, entities = { }, last_deployment = 0 },
        config = prototypes.mod_data["rabbasca-stabilizer-config"].data, -- accessing prototypes is expensive, so cache it here too
        is_booted = false
    }
    M.fuel.register_consumer(s, 1)
    s.get_inventory(defines.inventory.burnt_result).insert({name = "rabbasca-warp-cell-recharging", count = 2})
    for i, pos in pairs({ {-6, -6}, {-6, 6}, {6, -6}, {6, 6}}) do
        local e = s.surface.create_entity { 
            name = "rabbasca-stability-pylon",
            surface = s.surface,
            position = pos,
            force = s.force
        }
        local inv = e.get_inventory(defines.inventory.crafter_trash)
        if i == 1 then
            inv.insert({name = "ice", count = 39})
            inv.insert({name = "spoilage", count = 176})
        elseif i == 2 then
            inv.insert({name = "spoilage", count = 394})
        elseif i == 3 then
            inv.insert({name = "rabbasca-warp-cell-recharging", count = 1})
            inv.insert({name = "ice", count = 31})
        elseif i == 4 then
            inv.insert({name = "ice", count = 44})
            inv.insert({name = "rabbasca-powerspike", count = 1})
        end
        M.warp.register_floorthing(e)
    end
    for _, e in pairs(storage.stabilizer.flooring.entities) do
        e.on = false
        e.entity.health = 12
    end
    storage.stabilizer.fuel.recharger = s.surface.create_entity {
        name = "rabbasca-fuel-remote",
        surface = s.surface,
        position = { 0, 6 },
        force = s.force
    }
    M.warp.warp_to({ planet = "aquilo", guaranteed_manifestations = { 
        { type = "resource", name = "rabbasca-lithium-amide", floor = "volcanic-smooth-stone" },
        { type = "resource", name = "rabbasca-lithium-amide", floor = "volcanic-smooth-stone" }
    }})
    s.force.print({ "rabbasca-extra.created-underground-stabilizer", s.gps_tag})
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
        end
        for _, e in pairs(storage.stabilizer.fuel.consumers) do
            if e.entity.valid then e.entity.die() end
        end
        storage.stabilizer = nil
        M.update_logistic_section()

        for _, player in pairs(game.connected_players) do
            M.ui.clear_stabilizer_ui(player)
        end
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

function M.reboot_stabilizer()
    local s = storage.stabilizer and storage.stabilizer.entity
    if not (s and s.valid) then return end
    if s.force.technologies["rabbasca-warp-stabilizer"].researched then return end
    s.set_recipe("rabbasca-warp-trace")
    for _, player in pairs(game.connected_players) do
        M.ui.clear_stabilizer_ui(player)
    end
    s.force.technologies["rabbasca-warp-stabilizer"].researched = true
    s.force.print({ "rabbasca-extra.research-completed-reboot" }, { sount_path = "utility/research_completed" })
end

function M.repair_part()
    local s = storage.stabilizer and storage.stabilizer.entity
    if not (s and s.valid) then return end
    local recipe = (s.get_recipe() or { }).name
    if recipe == "rabbasca-repair-warpdrive" then
        storage.stabilizer.parts.warpdrive = true
        s.force.technologies["rabbasca-stabilizer-warpdrive"].researched = true
        s.get_inventory(defines.inventory.burnt_result).insert({ name = "rabbasca-warp-cell-recharging", count = 1 })
        s.force.print({ "rabbasca-extra.research-completed-repair-warpdrive" }, { sount_path = "utility/research_completed" })
    elseif recipe == "rabbasca-repair-extractor" then
        s.force.technologies["rabbasca-stabilizer-extractor"].researched = true
        s.get_inventory(defines.inventory.burnt_result).insert({ name = "rabbasca-warp-cell-recharging", count = 1 })
        s.force.print({ "rabbasca-extra.research-completed-repair-extractor" }, { sount_path = "utility/research_completed" })
    elseif recipe == "rabbasca-repair-relichunter" then
        s.force.technologies["rabbasca-stabilizer-relichunter"].researched = true
        s.get_inventory(defines.inventory.burnt_result).insert({ name = "rabbasca-warp-cell-recharging", count = 1 })
        s.force.print({ "rabbasca-extra.research-completed-repair-relichunter" }, { sount_path = "utility/research_completed" })
    end
    s.set_recipe("rabbasca-warp-trace")
    for _, player in pairs(game.connected_players) do
        M.ui.clear_stabilizer_ui(player)
    end
end

function M.toggle_component(recipe)
    local s = storage.stabilizer and storage.stabilizer.entity
    if not s then return end
    recipe = recipe or (s.get_recipe() and s.get_recipe().name)
    if not recipe then return end
    if recipe == "rabbasca-stabilizer-toggle-extractor" then
        if storage.stabilizer.parts.anomaly_extractor then
            storage.stabilizer.parts.anomaly_extractor.destroy{ }
            storage.stabilizer.parts.anomaly_extractor = nil
        else
            storage.stabilizer.parts.anomaly_extractor = storage.stabilizer.entity.surface.create_entity {
                name = "rabbasca-anomaly-extractor",
                position = storage.stabilizer.entity.position,
                force = storage.stabilizer.entity.force
            }
        end
    elseif recipe == "rabbasca-stabilizer-toggle-relichunter" then
        if storage.stabilizer.relics then
            storage.stabilizer.relics = nil
        else
            storage.stabilizer.relics = { pity = 0 }
        end
    end
    storage.stabilizer.entity.set_recipe("rabbasca-warp-trace")
end

function M.summon_fleet(surface, position)
    if not storage.stabilizer then return end
    local fuel_cost = prototypes.entity["rabbasca-ufo"].burner_prototype.initial_fuel.fuel_value
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
    register_stabilizer(stab)
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
        M.abandon(command.player_index and game.get_player(command.player_index))
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