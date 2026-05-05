local M = {
    ui = require("scripts.ui"),
    warp = require("scripts.warp")
}

local ENERGY_PER_CELL = 1000000000

local function logistics_group_name()
    return tostring(settings.global["rabbasca-underground-logistics-group-name"].value)
end

local function craft_without_fuel(fuel_remaining, e, speed_mod)
    local recipe = e.get_recipe()
    if fuel_remaining > 0 or (#recipe.ingredients > 0 and not e.is_crafting()) then return end
    -- e.crafting_progress = math.max(0, math.min(1, e.crafting_progress + (1/60/recipe.energy) * (speed_mod or 1) * e.crafting_speed))
    e.energy = 10000000
end

local function apply_upkeep(fuel)
    local new_fuel = fuel - storage.stabilizer.charge.upkeep / 3600 * ENERGY_PER_CELL
    if new_fuel < 0 then
        local fuel_inv = storage.stabilizer.entity.get_inventory(defines.inventory.fuel)
        for i = 1, #fuel_inv do
            local cell = fuel_inv[i]
            if cell.valid_for_read then
                storage.stabilizer.entity.burner.currently_burning = cell
                cell.clear()
                return new_fuel + ENERGY_PER_CELL
            end
        end
    end
    return math.max(0, new_fuel)
end

local function update_fuel()
    local recipe = storage.stabilizer.entity.get_recipe()
    local is_same_recipe = recipe and recipe.name == storage.stabilizer.charge.last_recipe or false
    local fuel_remaining = storage.stabilizer.entity.burner.remaining_burning_fuel
    local fuel_delta = (storage.stabilizer.charge.last_fuel or fuel_remaining) - fuel_remaining
    storage.stabilizer.charge.last_recipe = recipe and recipe.name or nil
    storage.stabilizer.charge.upkeep = 
          (((storage.stabilizer.safe_zone_radius or 10) - 10) * storage.stabilizer.settings.safe_zone_upkeep_per_radius)
        + (storage.stabilizer.parts.anomaly_extractor and 0.05 or 0)
    fuel_remaining = apply_upkeep(fuel_remaining)
    if not (is_same_recipe and fuel_delta >= 0) then
        storage.stabilizer.charge.last_fuel = nil
        storage.stabilizer.entity.burner.remaining_burning_fuel = fuel_remaining
        return
    end
    local settings = storage.stabilizer.config.recipe_settings[storage.stabilizer.charge.last_recipe]
    
    storage.stabilizer.charge.drain = 0
    if storage.stabilizer.charge.last_recipe == "rabbasca-stabilize-warpfield" then
        -- nothing
    elseif storage.stabilizer.charge.last_recipe == "rabbasca-stabilizer-warp-sequence" then
        storage.stabilizer.charge.drain = M.warp.get_warp_cost()
    elseif storage.stabilizer.charge.last_recipe == "rabbasca-abandon-stabilizer" then
        for _, player in pairs(storage.stabilizer.entity.force.players) do
            player.add_custom_alert(storage.stabilizer.entity, { type = "entity", name = "rabbasca-warp-stabilizer" }, { "rabbasca-extra.alert-abandon" }, true)
        end
    end

    if not (settings and settings.can_craft_for_free) then
        storage.stabilizer.entity.burner.remaining_burning_fuel = fuel_remaining - fuel_delta * storage.stabilizer.charge.drain
    else
        storage.stabilizer.entity.burner.remaining_burning_fuel = fuel_remaining + fuel_delta
        storage.stabilizer.charge.drain = 0
        craft_without_fuel(fuel_remaining, storage.stabilizer.entity, settings.freecraft_time_multiplier)
    end
    storage.stabilizer.charge.last_fuel = storage.stabilizer.entity.burner.remaining_burning_fuel
    
    local fuel_inv = storage.stabilizer.entity.get_inventory(defines.inventory.fuel)
    local has_cells = 0
    for i = 1, #fuel_inv do
        local cell = fuel_inv[i]
        if cell.valid_for_read and cell.name == "rabbasca-warp-cell" then
            cell.spoil_percent = 0
            has_cells = has_cells + 1
        end
    end

    storage.stabilizer.charge.cells_stored = has_cells + storage.stabilizer.entity.burner.remaining_burning_fuel / ENERGY_PER_CELL
    storage.stabilizer.charge.empty_since  = storage.stabilizer.charge.cells_stored <= 0 and (storage.stabilizer.charge.empty_since + 1) or 0
    if storage.stabilizer.charge.empty_since > storage.stabilizer.settings.miner_hibernation_timeout then
        if storage.stabilizer.parts.anomaly_extractor then
            M.toggle_component("rabbasca-anomaly-extractor")
        end
        if storage.stabilizer.parts.relichunter then
            M.toggle_component("rabbasca-anomaly-relichunter")
        end
    end
end

local function update_trash()
    local burnt_inv = storage.stabilizer.entity.get_inventory(defines.inventory.burnt_result)
    local has_excitement = burnt_inv.get_item_count("rabbasca-warp-cell-recharging") > 0
    -- for i = 1, #burnt_inv do
    --     if burnt_inv[i].valid_for_read and burnt_inv[i].name == "rabbasca-warp-cell-recharging" then
    --         -- has_excitement = true
    --         -- burnt_inv[i].spoil_percent = 0
    --     end
    -- end
    local trash_inv = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_trash)
    local traces = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_output).find_item_stack("rabbasca-warp-trace")
    if traces then 
        trash_inv.insert(traces)
        traces.clear()
    end
    local traces = trash_inv.find_item_stack("rabbasca-warp-trace")
    if not traces then return end
    traces.spoil_percent = 0

    if not (has_excitement and storage.stabilizer.settings.autofuel) then return end
    if burnt_inv.get_item_count("rabbasca-warp-trace") >= 5 and not storage.stabilizer.warping then return end
    traces.count = traces.count - burnt_inv.insert({name = "rabbasca-warp-trace", count = 1, quality = traces.quality})
end

function M.on_tick_underground(event)
    if not storage.stabilizer then return end
    if not storage.stabilizer.entity.valid then return end

    update_fuel()
    update_trash()

    if event.tick % 60 == 0 then
        if storage.stabilizer.anomalies then
            storage.stabilizer.anomalies.current = 0
            for _, e in pairs(storage.stabilizer.anomalies.entities) do
                if e.valid then
                    storage.stabilizer.anomalies.current = storage.stabilizer.anomalies.current + e.amount
                end
            end
            M.update_logistic_section()
        end
        if storage.stabilizer.entity.get_signal({ name = "rabbasca-warp-sequence", type = "item" }, defines.wire_connector_id.circuit_green, defines.wire_connector_id.circuit_red) > 0 then
            M.initiate_warp()
        end
    end

    -- if storage.stabilizer.settings.autopilot == true and M.warp.get_repair_progress() >= 1 then
    --     M.initiate_warp()
    -- end

    if event.tick % 5 == 0 and storage.stabilizer.warping then
        M.warp.on_warp_underground(event)
    end

    for _, player in pairs(game.connected_players) do
        M.ui.set_stabilizer_ui(player)
    end
end

local function give_starter_items()
    local s = storage.stabilizer.entity
    s.set_recipe("rabbasca-reboot-stabilizer")
    storage.stabilizer.entity.get_inventory(defines.inventory.burnt_result).insert({ name = "rabbasca-warp-cell-recharging", count = 3 })
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
            recall = false,
            autofuel = true,
            miner_hibernation_timeout = 2 * 3600,
            safe_zone_upkeep_per_radius = 0.0125
        },
        parts = {
            anomaly_extractor = nil,
            warpdrive = false,
            relichunter = nil
        },
        anomalies = { initial = 0, current = 0, entities = { }, trace_inventory = s.get_inventory(defines.inventory.crafter_trash) },
        config = prototypes.mod_data["rabbasca-stabilizer-config"].data, -- accessing prototypes is expensive, so cache it here too
        charge = { drain = 0, upkeep = 0, cells_stored = 0, empty_since = math.random(484, 865) * 3600 * 24 * 365 },
        is_booted = false
    }
    give_starter_items()
    M.warp.warp_to({ planet = "aquilo", guaranteed_manifestations = { 
        { type = "resource", name = "rabbasca-lithium-amide", floor = "volcanic-smooth-stone" },
        { type = "resource", name = "rabbasca-lithium-amide", floor = "volcanic-smooth-stone" }
    }})
    game.forces.player.chart(s.surface, {{-48, -48}, {48, 48}})
    game.forces.player.print({ "rabbasca-extra.created-underground-stabilizer", s.gps_tag})
end

function M.on_config_changed(handler)
    if not storage.stabilizer then return end
    storage.stabilizer.config = prototypes.mod_data["rabbasca-stabilizer-config"].data -- re-cache in case it changed
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
        game.forces.player.print({ "rabbasca-extra.stabilizer-destroyed" })
        if game.surfaces[storage.stabilizer.surface] and game.surfaces[storage.stabilizer.surface].valid then
            game.delete_surface(storage.stabilizer.surface)
        end
        for _, tech in pairs(storage.stabilizer.config.per_surface_techs) do
            game.forces.player.technologies[tech].researched = false
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

function M.attempt_cell_recharge(inventory_owner, auto_refuel)
    if not (inventory_owner and inventory_owner.valid) then return end
    local inventories_from = { defines.inventory.burnt_result, defines.inventory.fuel, defines.inventory.chest }
    for _, idx in pairs(inventories_from) do
        local inv = inventory_owner.get_inventory(idx)
        local cells = inv and inv.get_item_count("rabbasca-warp-cell-recharging") or 0
        local pity_per = 0.001 + 0.00075 / cells
        if cells > 0 then
            for i = 1,#inv do
                if inv[i].valid_for_read and inv[i].name == "rabbasca-warp-cell-recharging" then
                    local current = (inv[i].tags.chance or 0)
                    if math.random() <= current and inv[i].set_stack({name = "rabbasca-warp-cell", count = 1, quality = inv[i].quality, spoil_percent = 0 }) then
                        local fuel = auto_refuel and idx ~= defines.inventory.fuel and inventory_owner.get_inventory(defines.inventory.fuel)
                        if fuel and fuel.insert(inv[i]) then inv[i].clear() end
                    else
                        inv[i].tags = { chance = current + pity_per }
                        inv[i].spoil_percent = math.min(inv[i].spoil_percent, 0.9 - (inv[i].tags.chance * 5))
                        inv[i].custom_description = { "", { "item-description.rabbasca-warp-cell-recharging-tags", string.format("%.1f", inv[i].tags.chance * 100) }, { "item-description.rabbasca-warp-cell-recharging" } }
                    end
                end
            end
        end
    end
end

function M.reboot_stabilizer()
    local s = storage.stabilizer and storage.stabilizer.entity
    if not (s and s.valid) then return end
    if s.force.technologies["rabbasca-warp-stabilizer"].researched then return end
    -- local inv = s.get_inventory(defines.inventory.crafter_modules)
    -- local to_insert = 4
    -- for i = 1,#inv do
    --     if to_insert > 0 and not inv[i].valid_for_read then
    --         if inv[i].set_stack({name = "rabbasca-stabilizer-reboot-module", count = 1, spoil_percent = to_insert / 5 }) then
    --             to_insert = to_insert - 1
    --         end
    --     end
    -- end
    s.set_recipe("rabbasca-stabilize-warpfield")
    s.get_inventory(defines.inventory.crafter_trash).insert({name = "rabbasca-warp-trace", count = 400 + math.random(3, 31)})
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
        s.force.print({ "rabbasca-extra.research-completed-repair-warpdrive" }, { sount_path = "utility/research_completed" })
    elseif recipe == "rabbasca-repair-extractor" then
        s.force.technologies["rabbasca-stabilizer-extractor"].researched = true
        s.force.print({ "rabbasca-extra.research-completed-repair-extractor" }, { sount_path = "utility/research_completed" })
    elseif recipe == "rabbasca-repair-relichunter" then
        s.force.technologies["rabbasca-stabilizer-relichunter"].researched = true
        s.force.print({ "rabbasca-extra.research-completed-repair-relichunter" }, { sount_path = "utility/research_completed" })
    end
    s.set_recipe("rabbasca-stabilize-warpfield")
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
        storage.stabilizer.parts.relichunter = storage.stabilizer.parts.relichunter == nil and { pity = 0 } or nil
        game.print("RH "..serpent.line(storage.stabilizer.parts.relichunter))
    end
    storage.stabilizer.entity.set_recipe("rabbasca-stabilize-warpfield")
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

    commands.add_command("rabbasca_ug_charge", nil, function(command)
        storage.stabilizer.charge.current = tonumber(command.parameter) or storage.stabilizer.charge.current
    end)

    commands.add_command("rabbasca_ug_bye", nil, function(command)
        M.abandon(command.player_index and game.get_player(command.player_index))
    end)

    commands.add_command("rabbasca_ug_hey", nil, function(command)
        surface = game.planets["rabbasca-underground"].create_surface()
        M.on_locate_progress()
    end)

    commands.add_command("rabbasca_ug_repair", nil, function(command)
        for _, e in pairs(storage.stabilizer.entity.surface.find_entities_filtered { name = "rabbasca-warp-anomaly" }) do
            game.print(e.name)
            e.destroy { }
        end
    end)
end

return M