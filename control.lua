require("__planet-rabbasca__.api")
local underground = require("scripts.underground")
local sanity = require("scripts.sanity")

local function handle_script_events(event)
  local effect_id = event.effect_id
  if effect_id == "rabbasca_on_insanity_tick" then
    if event.target_entity then sanity.on_sanity_tick(event.target_entity) end
  elseif effect_id == "rabbasca_make_floor_anomaly" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      underground.on_progress_floor_anomaly(from)
    end
  elseif effect_id == "rabbasca_on_powerspike_progress" then
    underground.stab.progress_powerspike(1)
  elseif effect_id == "rabbasca_on_download_warp_science" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      underground.download_science(from)
    end
  elseif effect_id == "rabbasca_on_upload_warp_science" then
    local from = Rabbasca.get_spoiled_in(event)
    local _, quality = from and from.get_recipe()
    if from then
      underground.upload_science(10, quality and quality.name or "normal")
    end
  elseif effect_id == "rabbasca_on_relichunter_progress" then
    local from = Rabbasca.get_spoiled_in(event)
    local recipe = from and from.type == "assembling-machine" and from.get_recipe()
    if recipe and recipe.name == "rabbasca-hunt-anomalies" then
      underground.on_hunt_anomalies()
    elseif recipe and recipe.name == "rabbasca-hunt-relicaries" then
      underground.on_hunt_relicaries()
    end
  elseif effect_id == "rabbasca_on_spawn_ufo" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      from.surface.create_entity({
        name = "rabbasca-ufo",
        position = from.position,
        force = from.force
      })
    end
  elseif effect_id == "rabbasca_on_spawn_floorpylon" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      local pos = from.surface.find_non_colliding_position("rabbasca-stability-pylon", from.position, 10, 0.5)
      for _, ghost in pairs(from.surface.find_entities_filtered { name = "entity-ghost", ghost_name = "rabbasca-stability-pylon" }) do
        pos = ghost.position
        ghost.destroy { }
        if from.surface.create_entity({
          name = "rabbasca-stability-pylon",
          position = pos,
          force = from.force,
        }) then return end
      end
      if not from.surface.create_entity({
        name = "rabbasca-stability-pylon",
        position = pos,
        force = from.force
      }) then 
        game.print("Could not find a valid position to spawn [entity=rabbasca-stability-pylon]")
      end
    end
  elseif effect_id == "rabbasca_register_anomaly_miner" then
    underground.mining.on_add_miner(event.source_entity)
  elseif effect_id == "rabbasca_register_fuel_remote" then
    underground.fuel.register_provider(event.source_entity)
  elseif effect_id == "rabbasca_on_pylon_relocate" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      underground.warp.relocate_floorthing(from)
    end
  elseif effect_id == "rabbasca_on_summon_ufo" then
    local from = Rabbasca.get_spoiled_in(event)
    if from then
      underground.summon_fleet(from.surface, from.position)
    end
  elseif effect_id == "rabbasca_warp_progress_warp" then
    underground.warp.warp_to()
  elseif effect_id == "rabbasca_on_abandon" then
    underground.stab.abandon()
  elseif effect_id == "rabbasca_on_send_pylon_underground" then
    local from = Rabbasca.get_spoiled_in(event)
    underground.on_locate_progress(from)
  elseif effect_id == "rabbasca_register_fuel_consumer" then
    if event.source_entity then underground.fuel.register_consumer(event.source_entity) end
  elseif effect_id == "rabbasca_register_floorthing" then
    if event.source_entity then underground.warp.register_floorthing(event.source_entity) end
  elseif effect_id == "rabbasca_on_sanity_loss" then
    local from = Rabbasca.get_spoiled_in(event)
    local force = from and from.force or game.forces.player
    sanity.remove_sanity(force, sanity.DEFAULT_DRAIN)
  elseif effect_id == "rabbasca_on_sanity_restore" then
    local from = Rabbasca.get_spoiled_in(event)
    if from and from.type == "character" and from.force then
      if sanity.get_protection_level(from) > 0 then return end
      sanity.restore_sanity(from.force, sanity.DEFAULT_RESTORE)
    end
  end
end

script.on_event(defines.events.on_script_trigger_effect, handle_script_events)

script.on_event(defines.events.on_object_destroyed, function(event)
  if event.type == defines.target_type.entity then
    underground.on_stabilizer_died(event.registration_number)
    underground.fuel.on_consumer_died(event.registration_number)
    underground.warp.on_floorthing_died(event.registration_number)
  end
end)

script.on_event(defines.events.on_gui_opened, function(event)
    local player = game.get_player(event.player_index)
    if not player then return end

    if event.gui_type == defines.gui_type.entity then
      local entity = event.entity
      if entity and entity.valid then
        if entity.name == "rabbasca-warp-stabilizer" and entity.force == player.force then
          underground.ui.set_stabilizer_ui(player)
        elseif entity.name == "rabbasca-relicary-remote" and entity.force == player.force then
          underground.ui.set_relicary_remote_ui(player)
        end
      end
    elseif event.gui_type == defines.gui_type.item and event.item then
      if event.item.name:find("^rabbasca%-warp%-cell") then
        underground.ui.set_cell_ui(player, event.item)
      end
    elseif event.gui_type == defines.gui_type.controller then
      sanity.set_sanity_ui(player)
    end
end)

script.on_event(defines.events.on_gui_closed, function(event)
  local player = game.get_player(event.player_index)
    if event.gui_type == defines.gui_type.entity then
        if player then
            underground.ui.set_stabilizer_ui(player)
            underground.ui.set_relicary_remote_ui(player)
        end
    elseif event.gui_type == defines.gui_type.controller then
      sanity.set_sanity_ui(player)
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
  end
end)

script.on_event(defines.events.on_gui_click, function(event) 
  local player = game.players[event.player_index]
  if not player then return end
  if event.element.tags 
  and event.element.parent and event.element.parent.parent and event.element.parent.parent.name == "rabbasca_cell_targets" 
  and storage.assign_cell and storage.assign_cell[event.player_index] then
    local enum = event.element.tags.entity
    local cell = storage.assign_cell[event.player_index].item
    local e = game.get_entity_by_unit_number(enum or 0)
    if cell and e then
      underground.fuel.tether(cell, e)
    elseif cell then
      underground.fuel.untether(cell)
    end
  elseif event.element.name == "rabbasca_su_remote_select" then
      storage.assign_cell = storage.assign_cell or { }
      storage.assign_cell[event.player_index] = { chest = player.opened }
      player.opened = nil
  elseif event.element.name == "rabbasca_su_btn_repair_warpdrive" and storage.stabilizer then
    storage.stabilizer.entity.set_recipe("rabbasca-repair-warpdrive")
  elseif event.element.name == "rabbasca_su_btn_repair_extractor" and storage.stabilizer then
    storage.stabilizer.entity.set_recipe("rabbasca-repair-extractor")
  elseif event.element.name == "rabbasca_su_btn_repair_relichunter" and storage.stabilizer then
    storage.stabilizer.entity.set_recipe("rabbasca-repair-relichunter")
  elseif event.element.name == "rabbasca_relicary_reconnect" then
    local chest = game.players[event.player_index].opened
    if chest then
      for _, e in pairs(chest.surface.find_entities_filtered({name = "rabbasca-relicary"})) do
        chest.proxy_target_entity = e
      end
    end
  elseif event.element.name == "rabbasca_cell_confirm" then
      underground.ui.confirm_cell_selection(player)
  end
end)

script.on_event(defines.events.on_gui_switch_state_changed, function(event)
  local player = game.players[event.player_index]
  if not player then return end

  if event.element.name == "rabbasca_su_autopilot" then
    storage.stabilizer.settings.autopilot = event.element.switch_state == "right"
  end
end)

script.on_event(defines.events.on_tick, underground.on_tick_underground)

script.on_configuration_changed(underground.on_config_changed)