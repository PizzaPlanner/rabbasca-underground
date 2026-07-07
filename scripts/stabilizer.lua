local M = { }
local warp = require("scripts.warp")
local fuel = require("scripts.fuel")

function M.progress_powerspike(num)
    storage.stabilizer.powerspikes.next = storage.stabilizer.powerspikes.next - num
    if storage.stabilizer.powerspikes.next <= 0 then
        storage.stabilizer.entity.get_inventory(defines.inventory.crafter_trash).insert({ name = "rabbasca-powerspike", count = 1 })
        storage.stabilizer.powerspikes.created = storage.stabilizer.powerspikes.created + 1
        storage.stabilizer.powerspikes.required = M.get_powerspike_required(storage.stabilizer.powerspikes.created)
        storage.stabilizer.powerspikes.next = storage.stabilizer.powerspikes.next + storage.stabilizer.powerspikes.required
        local techs = storage.stabilizer.entity.force.technologies
        local tech = techs["rabbasca-warp-stabilizer-powerspike-"..storage.stabilizer.powerspikes.created.."-unlock"]
        storage.stabilizer.entity.force.print({ "rabbasca-extra.generated-powerspike", storage.stabilizer.powerspikes.created, storage.stabilizer.powerspikes.required }, { sound_path = "utility/achievement_unlocked" })
        if tech then
            tech.research_recursive()
            if tech.prototype.effects then
                for _, e in pairs(tech.prototype.effects) do
                    if e.type == "unlock-recipe" then storage.stabilizer.entity.force.print({ "rabbasca-extra.generated-powerspike-unlock", e.recipe }) end
                end
            end
        end
        if storage.stabilizer.powerspikes.next <= 0 then
            -- unlock another one
            M.progress_powerspike(0)
        end
    end
end

function M.get_powerspike_required(level)
    return math.floor(35 + level * (11.5 + level * 8.5))
end

function M.get_fuel_percentage()
    return storage.stabilizer.entity.burner.remaining_burning_fuel / fuel.ENERGY_PER_STAB_CELL
end

function M.fuel_alert()
    if not (storage.stabilizer and storage.stabilizer.entity and M.get_fuel_percentage() < 0.25) then return end
    storage.stabilizer.entity.force.add_custom_alert(storage.stabilizer.entity, { type = "entity", name = "rabbasca-warp-stabilizer" }, { "rabbasca-extra.alert-low-fuel" }, true)
    storage.stabilizer.entity.surface.play_sound({position = {0, 0}, path = "rabbasca-stabilizer-low-fuel", override_sound_type = "alert", volume_modifier = 0.5})
end

function M.register_stabilizer(s)
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
        fuel = { providers = { }, consumers = { }, cells = { } },
        miners = { entities = { } },
        powerspikes = { next = M.get_powerspike_required(0), required = M.get_powerspike_required(0), created = 0 },
        flooring = {
            entities = { },
            tiles = { },
            safe_tiles = { }
        },
        anomalies = { initial = 0, current = 0, entities = { }, last_deployment = 0 },
        config = prototypes.mod_data["rabbasca-stabilizer-config"].data, -- accessing prototypes is expensive, so cache it here too
        is_booted = false
    }
    -- M.fuel.register_consumer(s, 1)
    -- s.get_inventory(defines.inventory.burnt_result).insert({name = "rabbasca-warp-cell-recharging", count = 2})
    s.force.set_script_visible({ type = "tile", name = "rabbasca-underground-rubble-powered" }, true)
    s.force.set_script_visible({ type = "entity", name = "rabbasca-warp-stabilizer" }, true)
    s.force.set_script_visible({ type = "entity", name = "rabbasca-stability-pylon" }, true)
    s.force.set_script_visible({ type = "entity", name = "rabbasca-collector-pylon" }, true)
    s.force.set_script_visible({ type = "entity", name = "rabbasca-anomaly-storage" }, true)
    s.force.set_script_visible({ type = "item",   name = "rabbasca-warp-cell" }, true)
    s.force.set_script_visible({ type = "item",   name = "rabbasca-warp-cell-recharging" }, true)
    s.force.set_script_visible({ type = "item",   name = "rabbasca-powerspike" }, true)
    s.surface.create_entity { 
        name = "rabbasca-collector-pylon",
        surface = s.surface,
        position = {6, 0},
        direction = defines.direction.east,
        force = s.force
    }
    local chest = s.surface.create_entity {
        name = "rabbasca-anomaly-storage",
        surface = s.surface,
        position = { 0, 6 },
        force = s.force
    }
    -- chest.health = 127
    storage.stabilizer.miners.chest = chest
    local inv = chest.get_inventory(defines.inventory.chest)
    inv.insert({name = "rabbasca-warp-cell-recharging", count = 4})
    inv.insert({name = "rabbasca-powerspike", count = 1})
    inv.insert({name = "spoilage", count = 367})
    inv.insert({name = "ice", count = 114})
    for i = 1, #inv do
        if inv[i].valid_for_read and inv[i].name == "rabbasca-warp-cell-recharging" then
            fuel.untether(inv[i].item)
        end
    end
    for i, pos in pairs({ {-6, -6}, {-6, 6}, {6, -6}, {6, 6}}) do
        local e = s.surface.create_entity { 
            name = "rabbasca-stability-pylon",
            surface = s.surface,
            position = pos,
            force = s.force
        }
    end
    for _, e in pairs(storage.stabilizer.flooring.entities) do
        e.on = false
        e.entity.health = 12
    end
    warp.warp_to({ planet = "aquilo", guaranteed_manifestations = { 
        { type = "resource", name = "rabbasca-lithium-amide", floor = "volcanic-smooth-stone" },
        { type = "resource", name = "rabbasca-lithium-amide", floor = "volcanic-smooth-stone" }
    }})
    s.force.print({ "rabbasca-extra.created-underground-stabilizer", s.gps_tag})
end

function M.abandon(player)
    if storage.stabilizer and storage.stabilizer.entity then
        storage.stabilizer.entity.die(nil, player and player.character)
        if player then
            game.print({ "rabbasca-extra.stabilizer-abandoned", player.name })
        end
    end
end


local function craft_without_fuel(e)
    -- local recipe = e.get_recipe()
    -- if (#recipe.ingredients > 0 and not e.is_crafting()) then return end
    e.energy = e.burner.heat_capacity
end

function M.update_crafting()
    local recipe = storage.stabilizer.entity.get_recipe()
    if not recipe then return end
    recipe = recipe.name
    craft_without_fuel(storage.stabilizer.entity)
    if recipe == "rabbasca-warp-trace" then
        -- nothing
    elseif recipe == "rabbasca-stabilizer-warp-sequence" then
        if not warp.is_box_safe({left_top = { x = -4, y = -4 }, right_bottom = { x = 4, y = 4 }}) then
            storage.stabilizer.entity.crafting_progress = 0
            if game.tick % 240 == 0 then
                for _, player in pairs(storage.stabilizer.entity.force.players) do
                    player.create_local_flying_text { text = {"rabbasca-extra.warp-paused-not-safe" }, surface = storage.stabilizer.entity.surface, position = storage.stabilizer.entity.position }
                end
            end
        end
    elseif recipe == "rabbasca-abandon-stabilizer" then
        for _, player in pairs(storage.stabilizer.entity.force.players) do
            player.add_custom_alert(storage.stabilizer.entity, { type = "entity", name = "rabbasca-warp-stabilizer" }, { "rabbasca-extra.alert-abandon" }, true)
        end
    end
end

function M.trace_stasis()
    local trash_inv = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_trash)
    
    local traces = storage.stabilizer.entity.get_inventory(defines.inventory.crafter_output).find_item_stack("rabbasca-warp-trace")
    local saved = trash_inv.find_item_stack("rabbasca-warp-trace")
    local missing = 500 - (saved and saved.count or 0)
    if traces then
        local transferred = math.min(missing, math.max(1, math.floor(traces.count / 25)))
        if transferred > 0 then
            traces.count = traces.count - trash_inv.insert({ name = "rabbasca-warp-trace", count = transferred})
        end
    end
    if not saved then return end
    local burner = storage.stabilizer.entity.burner
    local refill_value = 50000000/60
    if not burner.currently_burning then
        saved.count = saved.count - 1
        burner.currently_burning = "rabbasca-warp-cell-internal-big"
        burner.remaining_burning_fuel = refill_value
    elseif burner.remaining_burning_fuel < burner.currently_burning.name.fuel_value - refill_value then
        saved.count = saved.count - 1
        burner.remaining_burning_fuel = burner.remaining_burning_fuel + refill_value
    end
    if storage.stabilizer.warping ~= nil then return end
    saved.spoil_percent = 0
end

return M