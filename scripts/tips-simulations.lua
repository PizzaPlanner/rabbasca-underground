require("__core__/lualib/story")
require("__planet-rabbasca__.control")
require("__rabbasca-underground__.control") -- Order important, events override. TODO: Switch to event_handler
local underground = require("__rabbasca-underground__.scripts.underground")
Rabbasca.events.init_simulation()

function refuel(miners, floories)
    if game.tick % 10 ~= 0 then return end
    if floories then
        for _, e in pairs(storage.stabilizer.entity.surface.find_entities_filtered{name = "rabbasca-stability-pylon"}) do
            e.burner.remaining_burning_fuel = underground.fuel.ENERGY_PER_CELL
        end
    end
    if miners then
        for _, e in pairs(storage.stabilizer.entity.surface.find_entities_filtered{name = "rabbasca-collector-pylon"}) do
            e.burner.remaining_burning_fuel = underground.fuel.ENERGY_PER_CELL
        end
    end
end

-- script.on_event(on_tick) is blocked by story 
function rabbasca_ug_sim_tick()
    underground.on_tick_underground({ tick = game.tick })
end

function simulation_relocation()
    local surface = game.create_surface("rabbasca-underground", game.planets["rabbasca-underground"].prototype.map_gen_settings)
    surface.ignore_surface_conditions = true
    underground.init_underground(surface)
    local stab = storage.stabilizer.entity
    assert(stab and stab.valid, "Stabilizer not generated")

    local player = game.simulation.create_test_player { name = "Underground worker" }
    player.teleport({6, 5}, surface) -- Cant enter remote view
    player.force.technologies["rabbasca-underground"].research_recursive()

    game.simulation.camera_player = player
    game.simulation.camera_position = { 6, 6 }
    game.simulation.camera_alt_info = true
    game.simulation.camera_zoom = 0.5
    game.simulation.camera_player_cursor_position = { 4, 4 }
    game.simulation.gui_tooltip_interval = 0.5
    local story_table =
    {
      {
        {
          name = "start",
          condition = story_elapsed_check(8),
        },
        { 
            condition = function() return game.simulation.move_cursor({ position = {6, 6}, speed = 0.15 }) end,
            action = function()
                local pylon = surface.find_entity("rabbasca-stability-pylon", {6, 6})
                pylon.set_recipe(nil)
                player.opened = pylon
            end, 
        },
        {
            condition = function() 
                local target = game.simulation.get_widget_position({type = "recipe-slot", recipe = "rabbasca-relocate-floorthing" })
                -- if not target then return false end
                return game.simulation.move_cursor({position = target, speed = 0.25})
            end
        },
        {
            condition = story_elapsed_check(2),
            action = function() game.simulation.mouse_click() end
        },
        {
            condition = story_elapsed_check(2),
            action = function() player.opened = nil end
        },
        {
            condition = function() 
                return game.simulation.move_cursor({ position = {6, 6} })
            end,
        },
        {
            init = function() player.insert("rabbasca-stability-pylon") end,
            condition = story_elapsed_check(0.5),
            action = function() game.simulation.control_press{ control = "pipette", notify = true } end
        },
        {
            condition = story_elapsed_check(0.5),
        },
        {
            condition = function() return game.simulation.move_cursor({position = {12, 6}}) end,
            action = function() game.simulation.control_press{ control = "build-ghost", notify = true } end
        },
        {
            condition = story_elapsed_check(2),
            action = function() 
                game.simulation.control_press{ control = "clear-cursor", notify = false }
            end
        },
        {
            condition = story_elapsed_check(5),
        },
        { 
            condition = function() 
                player.insert({name = "rabbasca-collector-pylon", count = 5})
                player.cursor_stack.set_stack({name = "rabbasca-collector-pylon"})
                return game.simulation.move_cursor({position = {-1, 9}}) 
            end},
        {
          init = function() game.simulation.control_down{control = "build", notify = false} end,
          condition = function() return game.simulation.move_cursor({position = {16, 9}}) end,
          action = function() game.simulation.control_up{control = "build"} end
        },
        {
            condition = story_elapsed_check(10),
            action = function()
                player.cursor_stack.clear()
                player.create_local_flying_text{ text = "speed x5", create_at_cursor = true }
                game.speed = 5
            end,
        },
        {
            condition = story_elapsed_check(6),
            action = function() game.simulation.camera_zoom = 0.2 end
        }
      }
    }

    tip_story_init(story_table)

end

function simulation_briefing()

    local player = game.simulation.create_test_player { name = "Underground worker" }
    local surface = game.create_surface("rabbasca-underground", game.planets["rabbasca-underground"].prototype.map_gen_settings)
    underground.init_underground(surface)
    local stab = storage.stabilizer.entity
    assert(stab and stab.valid, "Stabilizer not generated")

    player.teleport({0, 0}, surface)
    player.force.technologies["rabbasca-warp-stabilizer-powerspike-1-unlock"].research_recursive()

    game.simulation.camera_player = player
    game.simulation.camera_alt_info = true
    game.simulation.camera_zoom = 0.9
    game.simulation.camera_player_cursor_position = stab.position

    stab.set_recipe("rabbasca-warp-trace")    
    storage.warp_inventory.insert("harene-infused-cryogenic-plant")
    storage.warp_inventory.insert("concrete")
    
    local story_table =
    {{
        { condition = story_elapsed_check(12), },
        {
            action = function()
                surface.create_entity {
                    name = "rabbasca-warp-pylon",
                    position = {0, 10},
                    force = player.force,
                    snap_to_grid = true,
                    raise_built = true
                }
            end
        },
        { 
            condition = story_elapsed_check(4), 
            action = function()
                surface.create_entity{ name = "entity-ghost", inner_name = "harene-infused-cryogenic-plant", force = player.force, position = {-10, 0}, raise_built = true }.set_recipe("rabbasca-underground-aquilo-extract-atmosphere")
                for x = 12,32 do
                    surface.create_entity{ name = "tile-ghost", inner_name = "concrete", force = player.force, position = {x, 0}, raise_built = true }
                end
                for x = 6,32 do
                    surface.create_entity{ name = "entity-ghost", inner_name = "transport-belt", force = player.force, position = {x, 0}, raise_built = true, direction = defines.direction.west }
                end
            end
        },
    }}
    tip_story_init(story_table)
end

function simulation_fuel_management()
    local surface = game.create_surface("rabbasca-underground", game.planets["rabbasca-underground"].prototype.map_gen_settings)
    underground.init_underground(surface)
    local stab = storage.stabilizer.entity
    assert(stab and stab.valid, "Stabilizer not generated")

    local player = game.simulation.create_test_player { name = "Underground worker" }
    -- player.set_controller{ type = defines.controllers.remote }
    player.teleport({0, 0}, surface)
    player.force.technologies["rabbasca-underground"].research_recursive()

    game.simulation.camera_player = player
    game.simulation.camera_alt_info = true
    game.simulation.camera_zoom = 0.8
    game.simulation.camera_player_cursor_position = stab.position
    game.simulation.gui_tooltip_interval = 0.5

    stab.burner.remaining_burning_fuel = underground.fuel.ENERGY_PER_STAB_CELL * 0.5

    local story_table =
    {
      {
        {
          name = "start",
          condition = story_elapsed_check(5),
        },
        {
            condition = story_elapsed_check(0.25),
        },
        {
            action = function() stab.set_recipe("rabbasca-warp-trace") player.opened = stab end
        },
        {
            condition = story_elapsed_check(2),
        },
        { 
            condition = function()
                local target = game.simulation.get_widget_position({type = "label",  text = "    " })
                target.y = target.y + 1
                return game.simulation.move_cursor({position = target, speed = 0.25})
            end
        },
        { 
            condition = story_elapsed_check(2),
            action = function() game.simulation.control_press{ control = "open-item", notify = true } end
        },
        {
            condition = story_elapsed_check(1),
        },
        { 
            condition = function()
                -- local frame = player.gui.screen.rabbasca_cell_assignment
                -- local target = game.simulation.get_widget_position({type = "signal-id-base", id = { type = "entity", name = "rabbasca-collector-pylon" } })
                return game.simulation.move_cursor({position = {-3, -3}, speed = 0.25})
            end
        },
        {
            condition = story_elapsed_check(1),
        },
        { 
            init = function() game.simulation.mouse_click() end,
            condition = story_elapsed_check(1),
        },
        {
            condition = function()
                return game.simulation.move_cursor({position = {-3, -6}, speed = 0.1})
            end
        },
        {
            condition = story_elapsed_check(10),
            action = function() game.simulation.mouse_click() end
        },
        {
            condition = story_elapsed_check(5),
            action = function() player.opened = nil end
        },
        {
            condition = story_elapsed_check(1),
            action = function() player.opened = storage.stabilizer.miners.chest end
        },
      }
    }

    tip_story_init(story_table)


    -- game.simulation.write{text = "I am on "..player.surface.index..", stab is on "..stab.surface_index}
end