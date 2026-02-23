require("__planet-rabbasca__.api")
local underground = require("scripts.underground")

local function handle_script_events(event)
  local effect_id = event.effect_id
  if effect_id == "rabbasca_warp_progress" then
    underground.on_stabilization()
  elseif effect_id == "rabbasca_warp_progress_warp" then
    underground.initiate_warp()
  elseif effect_id == "rabbasca_warp_unprogress" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      underground.on_destabilization(from)
    end
  elseif effect_id == "rabbasca_on_reboot_underground" then
    underground.reboot_stabilizer()
  elseif effect_id == "rabbasca_on_send_pylon_underground" then
    local from = Rabbasca.get_spoiled_in(event)
    underground.on_locate_progress(from)
  end
end

script.on_event(defines.events.on_script_trigger_effect, handle_script_events)

script.on_event(defines.events.on_object_destroyed, function(event)
  if event.type == defines.target_type.entity then
    underground.on_stabilizer_died(event.registration_number)
  end
end)

script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.players[event.player_index]
    underground.ui.update_affinity_bar(player)
end)

script.on_event(defines.events.on_surface_created, function(event)
  if (game.planets["rabbasca-underground"] and game.planets["rabbasca-underground"].surface and event.surface_index == game.planets["rabbasca-underground"].surface.index) then
    underground.init_underground(game.surfaces[event.surface_index])
  end
end)

script.on_event(defines.events.on_gui_opened, function(event)
    if event.gui_type ~= defines.gui_type.entity then return end
    if not event.entity or not event.entity.valid then return end
    local player = game.get_player(event.player_index)
    if not player then return end

    local entity = event.entity
    if entity.name == "rabbasca-warp-stabilizer" and entity.force == player.force then
      underground.ui.set_stabilizer_ui(player)
    end
end)

script.on_event(defines.events.on_gui_click, function(event) 
  if event.element.name == "rabbasca_su_manual_warp" then
    underground.initiate_warp()
  elseif event.element.name == "rabbasca_ug_current_planet" and storage.stabilizer then
    game.players[event.player_index].opened = storage.stabilizer.entity
  end
end)

script.on_event(defines.events.on_gui_switch_state_changed, function(event)
  local player = game.players[event.player_index]
  if not player then return end
  if event.element.name == "rabbasca_su_switch_miner_reboot" then
    underground.reboot_stabilizer(game.players[event.player_index], event.element.switch_state == "right")
    player.gui.relative.rabbasca_stabilizer_ui.destroy()
  elseif event.element.name == "rabbasca_su_manual_warp" and event.element.switch_state == "right" then
    underground.initiate_warp(player)
    player.gui.relative.rabbasca_stabilizer_ui.destroy()
  elseif event.element.name == "rabbasca_su_abandon" and event.element.switch_state == "right" then
    underground.abandon(player)
    -- player.gui.relative.rabbasca_stabilizer_ui.destroy()
  elseif event.element.name == "rabbasca_su_autopilot" then
    storage.stabilizer.settings.autopilot = event.element.switch_state == "right"
  elseif event.element.name == "rabbasca_su_recall" then
    storage.stabilizer.settings.recall = event.element.switch_state == "right"
  end
end)

script.on_event(defines.events.on_gui_value_changed, function(event)
  if event.element.name == "rabbasca_su_safe_zone" then
    storage.stabilizer.safe_zone_setting = event.element.slider_value
  end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    if event.gui_type == defines.gui_type.entity then
        local player = game.get_player(event.player_index)
        if player then
            underground.ui.set_stabilizer_ui(player)
        end
    end
end)

script.on_event(defines.events.on_tick, underground.on_tick_underground)

script.on_configuration_changed(underground.on_config_changed)