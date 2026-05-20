require("__planet-rabbasca__.api")
local underground = require("scripts.underground")

local function handle_script_events(event)
  local effect_id = event.effect_id
  if effect_id == "rabbasca_on_trace_spoiled" then
    local target = Rabbasca.get_spoiled_in(event)
    underground.fuel.attempt_cell_recharge(target, true)
  elseif effect_id == "rabbasca_warp_unprogress" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      underground.on_destabilization(from)
    end
  elseif effect_id == "rabbasca_on_reboot_underground" then
    underground.reboot_stabilizer()
  elseif effect_id == "rabbasca_on_repair_component" then
    underground.repair_part()
  elseif effect_id == "rabbasca_on_toggle_component" then
    underground.toggle_component()
  elseif effect_id == "rabbasca_on_summon_ufo" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      underground.summon_fleet(from.surface, from.position)
    end
  elseif effect_id == "rabbasca_warp_progress_warp" then
    underground.warp.warp_to()
  elseif effect_id == "rabbasca_on_abandon" then
    underground.abandon()
  elseif effect_id == "rabbasca_on_send_pylon_underground" then
    local from = Rabbasca.get_spoiled_in(event)
    underground.on_locate_progress(from)
  elseif effect_id == "rabbasca_register_fuel_consumer" then
    if event.source_entity then underground.fuel.register_consumer(event.source_entity) end
  elseif effect_id == "rabbasca_register_floorthing" then
    if event.source_entity then underground.warp.register_floorthing(event.source_entity) end
  end
end

script.on_event(defines.events.on_script_trigger_effect, handle_script_events)

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
  underground.fuel.rescue_cell(event.entity)
end, {
  { filter = "name", name = "rabbasca-stability-pylon" }, 
  { filter = "name", name = "rabbasca-relichunter" }, 
  { filter = "name", name = "rabbasca-collector-pylon" }
})

script.on_event(defines.events.on_object_destroyed, function(event)
  if event.type == defines.target_type.entity then
    underground.on_stabilizer_died(event.registration_number)
    underground.fuel.on_consumer_died(event.registration_number)
    underground.warp.on_floorthing_died(event.registration_number)
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
    elseif entity.name == "rabbasca-relicary-remote" and entity.force == player.force then
      underground.ui.set_relicary_remote_ui(player)
    elseif entity.name == "rabbasca-fuel-remote" and entity.force == player.force then
      underground.ui.set_fuel_remote_ui(player)
    end
end)

script.on_event(defines.events.on_gui_selection_state_changed, function(event)
  if event.element.name == "rabbasca_relicary_target_inventory" then
    local player = game.players[event.player_index]
    if not (player.opened and player.opened.name == "rabbasca-relicary-remote") then return end
    player.opened.proxy_target_inventory = 
           (event.element.selected_index == 1 and defines.inventory.crafter_input)
        or (event.element.selected_index == 2 and defines.inventory.crafter_output)
        or (event.element.selected_index == 3 and defines.inventory.fuel)
        or defines.inventory.burnt_result
  elseif event.element.name == "rabbasca_su_fuel_strategy" then
    local player = game.players[event.player_index]
    if not (player.opened and player.opened.name == "rabbasca-fuel-remote") then return end
    storage.stabilizer.fuel.selection_strategy.filter = event.element.selected_index
  end
end)

script.on_event(defines.events.on_gui_click, function(event) 
  if event.element.name == "rabbasca_su_btn_reboot_main" then
    storage.stabilizer.entity.set_recipe("rabbasca-reboot-stabilizer")
    game.auto_save("rabbasca-first-stabilizer-reboot")
  elseif event.element.name == "rabbasca_su_btn_repair_warpdrive" and storage.stabilizer then
    storage.stabilizer.entity.set_recipe("rabbasca-repair-warpdrive")
  elseif event.element.name == "rabbasca_su_btn_repair_extractor" and storage.stabilizer then
    storage.stabilizer.entity.set_recipe("rabbasca-repair-extractor")
  elseif event.element.name == "rabbasca_su_btn_repair_relichunter" and storage.stabilizer then
    storage.stabilizer.entity.set_recipe("rabbasca-repair-relichunter")
  elseif event.element.parent and event.element.parent.name == "rabbasca_su_fuel_targets" then
    local tags = event.element.tags
    if tags then
      underground.fuel.set_target(tags)
    end
  elseif event.element.name == "rabbasca_relicary_reconnect" then
    local chest = game.players[event.player_index].opened
    if chest then
      for _, e in pairs(chest.surface.find_entities_filtered({name = "rabbasca-relicary"})) do
        chest.proxy_target_entity = e
      end
    end
  end
end)

script.on_event(defines.events.on_gui_switch_state_changed, function(event)
  local player = game.players[event.player_index]
  if not player then return end

  if event.element.name == "rabbasca_su_autopilot" then
    storage.stabilizer.settings.autopilot = event.element.switch_state == "right"
  elseif event.element.name == "rabbasca_su_fuel_signal_switch" then
      storage.stabilizer.fuel.selector.read_from_network = event.element.switch_state == "right"
      storage.assign_remote = storage.assign_remote or { }
      storage.assign_remote[event.player_index] = { chest = player.opened }
      player.opened = nil
  end
end)

script.on_event(defines.events.on_gui_value_changed, function(event)
  if event.element.name == "rabbasca_su_miners_target" then
    storage.stabilizer.miners.active_target = event.element.slider_value
  end
end)

script.on_event(defines.events.on_gui_closed, function(event)
    if event.gui_type == defines.gui_type.entity then
        local player = game.get_player(event.player_index)
        if player then
            underground.ui.set_stabilizer_ui(player)
            underground.ui.set_relicary_remote_ui(player)
            underground.ui.set_fuel_remote_ui(player)
        end
    end
end)

script.on_event(defines.events.on_tick, underground.on_tick_underground)

script.on_configuration_changed(underground.on_config_changed)