if not data then return end

local function create_affinity_tech(planet)
  local tech_flex = {
    type = "technology",
    name = "rabbasca-warp-anchoring-"..planet,
    icons = Rabbasca.icons({
        { proto = data.raw["technology"]["planet-discovery-"..planet] or data.raw["planet"][planet], scale = 0.8 },
        { proto = data.raw["assembling-machine"]["rabbasca-warp-stabilizer"], scale = 1 }
    }),
    enabled = false,
    rabbasca_underground_temporary = true,
    prerequisites = { "rabbasca-warp-stabilizer" },
    effects = { },
    localised_name = { "technology-name.rabbasca-warp-anchoring", planet },
    localised_description = { "technology-description.rabbasca-warp-anchoring", planet },
    research_trigger =
    {
        type = "scripted",
        trigger_description = { "rabbasca-extra.trigger-rabbasca-warp-current", planet }
    }
  }
  local mod_data = data.raw["mod-data"]["rabbasca-stabilizer-config"]
  mod_data.data.planets[planet].tech = tech_flex.name
--   mod_data.data.planets[planet].tech_prep = tech_pre.name
  data:extend{
    -- tech_pre,
    tech_flex,
  }
end

Rabbasca.Stabilizer = { }

function Rabbasca.Stabilizer.add_location(config)
    local mod_data = data.raw["mod-data"]["rabbasca-stabilizer-config"]
    mod_data.data.planets[config.planet] = {
        water = config.filler_tile or "lava-hot",
        autoplace_entities = { ["rabbasca-warp-anomaly"] = { } },
        anomaly_replace_entities = config.anomaly_replace_entities or { },
        min_stay = config.min_stay or 50,
        max_stay = config.max_stay or 75,
        lut = config.lut_texture or "identity",
        tech = nil,
        -- tech_prep = nil,
        -- in final fixes for better change resilience
        fluid = nil,
        lut_index = nil
    }
    for _, e in pairs(config.autoplace_entities or { }) do 
        mod_data.data.planets[config.planet].autoplace_entities[e] = { }
    end
    create_affinity_tech(config.planet)
    -- local tech_pre = data.raw["technology"]["rabbasca-warp-prep-"..config.planet]
    -- for _, recipe in pairs(config.permanent_recipes or { }) do
    --     table.insert(tech_pre.effects, { type = "unlock-recipe", recipe = recipe })
    -- end
end

function Rabbasca.Stabilizer.make_atmospheric_recipe(planet, results)
    local name = results[1].name
    table.insert(data.raw["technology"]["rabbasca-warp-anchoring-"..planet].effects, { type = "unlock-recipe", recipe = "rabbasca-underground-"..planet.."-extract-atmosphere" })
    return {
        type = "recipe",
        name = "rabbasca-underground-"..planet.."-extract-atmosphere",
        icons = Rabbasca.icons({
            { proto = data.raw["fluid"][name], scale = 0.8 },
            { proto = data.raw["planet"]["rabbasca-underground"], scale = 0.3, shift = {-8, -8} },
        }),
        energy_required = 5,
        localised_name = { "recipe-name.rabbasca-underground-extract-atmosphere", { "fluid-name."..name } },
        localised_description = { "recipe-description.rabbasca-local-materialize", planet },
        ingredients = { },
        results = results,
        enabled = false,
        auto_recycle = false,
        surface_conditions = { Rabbasca.only_underground() },
        category = "cryogenics",
        subgroup = "rabbasca-remote",
        order = "f[planet]-"..planet.."-d[atmosphere]-"..name,
    }
end

function Rabbasca.Stabilizer.make_pylon_recipe(name, type, planet, results, ingredients)
    table.insert(data.raw["technology"]["rabbasca-warp-anchoring-"..planet].effects, { type = "unlock-recipe", recipe = "rabbasca-local-materialize-"..name })
    return {
        type = "recipe",
        name = "rabbasca-local-materialize-"..name,
        icons = Rabbasca.icons({
            { proto = data.raw[type][name], scale = 0.8 },
            { proto = data.raw["tool"]["rabbasca-warp-matrix"], scale = 0.3, shift = {-8, -8} },
        }),
        energy_required = 2,
        localised_name = { "recipe-name.rabbasca-local-materialize", { type == "fluid" and "fluid-name."..name or "item-name."..name } },
        localised_description = { "recipe-description.rabbasca-local-materialize", planet },
        ingredients = ingredients,
        results = results,
        enabled = false,
        auto_recycle = false,
        surface_conditions = { Rabbasca.only_underground(true) },
        category = "rabbasca-remote",
        subgroup = "rabbasca-remote",
        order = "f[planet]-"..planet.."-b[materialized]-"..name,
    }
end

function Rabbasca.underground_pressure() return 45312 end

function Rabbasca.only_underground(needs_stabilizer)
    if needs_stabilizer then return { property = "rabbasca-underground", min = 1, max = 1 }
    else return { property = "pressure", min = Rabbasca.underground_pressure(), max = Rabbasca.underground_pressure() } end
end

function Rabbasca.not_underground()
    return { property = "rabbasca-underground", min = 0, max = 0 }
end