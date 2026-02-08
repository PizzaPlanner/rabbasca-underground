require("__planet-rabbasca__.api")
local underground = require("scripts.underground")

local function handle_script_events(event)
  local effect_id = event.effect_id
  if effect_id == "rabbasca_warp_progress" then
    underground.on_stabilization()
  elseif effect_id == "rabbasca_on_reboot_underground" then
    underground.reboot_stabilizer()
  elseif effect_id == "rabbasca_on_send_pylon_underground" then
    local from = Rabbasca.get_spoiled_in(event)
    underground.on_locate_progress(from)
  end
end

script.on_event(defines.events.on_script_trigger_effect, handle_script_events)

script.on_load(function()
    underground.register_handlers()
end)

script.on_event(defines.events.on_object_destroyed, function(event)
  if event.type == defines.target_type.entity then
    underground.on_stabilizer_died(event.registration_number)
  end
end)

script.on_event(defines.events.on_player_changed_surface, function(event)
    local player = game.players[event.player_index]
    underground.update_affinity_bar(player)
end)

script.on_event(defines.events.on_surface_created, function(event)
  if (game.planets["rabbasca-underground"] and game.planets["rabbasca-underground"].surface and event.surface_index == game.planets["rabbasca-underground"].surface.index) then
    underground.init_underground(game.surfaces[event.surface_index])
  end
end)

script.on_event(defines.events.on_gui_click, function(event)
  if event.element.name == "rabbasca_abandon_stabilizer" then
    event.element.parent.add{
      type = "sprite-button",
      sprite = "virtual-signal/signal-check",
      style = "shortcut_bar_button_red",
      name = "rabbasca_abandon_stabilizer_confirm",
      tooltip = { "rabbasca-extra.abandon-stabilizer" }
    }
    event.element.destroy()
  elseif event.element.name == "rabbasca_abandon_stabilizer_confirm" then
    underground.abandon(game.players[event.player_index])
  end
end)

script.on_configuration_changed(underground.on_config_changed)