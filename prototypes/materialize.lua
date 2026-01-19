local mod_data = {
    type = "mod-data",
    name = "rabbasca-stabilizer-config",
    data = { planets = { }, water_tiles = { }, stabilization_required = 100 }
}

local function add_planet(name, fluid_tile, entities, lut)
    mod_data.data.planets[name] = {
        water = fluid_tile,
        fluid = nil, -- in final fixes for better change resilience
        autoplace_entities = { },
        lut = lut,
        tech = nil,
        tech_prep = nil,
        lut_index = nil
    }
    if entities then
        for _, e in pairs(entities) do 
            mod_data.data.planets[name].autoplace_entities[e] = { }
        end    
    end
end

local function make_atmospheric_recipe(affinity, results)
    local name = results[1].name
    table.insert(data.raw["technology"]["rabbasca-warp-anchoring-"..affinity].effects, { type = "unlock-recipe", recipe = "rabbasca-underground-"..affinity.."-extract-atmosphere" })
    return {
        type = "recipe",
        name = "rabbasca-underground-"..affinity.."-extract-atmosphere",
        icons = Rabbasca.icons({
            { proto = data.raw["fluid"][name], scale = 0.8 },
            { proto = data.raw["planet"]["rabbasca-underground"], scale = 0.3, shift = {-8, -8} },
        }),
        energy_required = 5,
        localised_name = { "recipe-name.rabbasca-underground-extract-atmosphere", { "fluid-name."..name } },
        localised_description = { "recipe-description.rabbasca-attuned-materialize", affinity },
        ingredients = { },
        results = results,
        enabled = false,
        auto_recycle = false,
        surface_conditions = { Rabbasca.only_underground() },
        category = "cryogenics",
        subgroup = "rabbasca-remote",
        order = "f[planet]-"..affinity.."-d[atmosphere]-"..name,
    }
end

local function make_materialize_recipe(name, type, affinity, results, ingredients)
    table.insert(data.raw["technology"]["rabbasca-warp-anchoring-"..affinity].effects, { type = "unlock-recipe", recipe = "rabbasca-attuned-materialize-"..name })
    return {
        type = "recipe",
        name = "rabbasca-attuned-materialize-"..name,
        icons = Rabbasca.icons({
            { proto = data.raw[type][name], scale = 0.8 },
            { proto = data.raw["tool"]["rabbasca-warp-matrix"], scale = 0.3, shift = {-8, -8} },
        }),
        energy_required = 10,
        localised_name = { "recipe-name.rabbasca-attuned-materialize", { type == "fluid" and "fluid-name."..name or "item-name."..name } },
        localised_description = { "recipe-description.rabbasca-attuned-materialize", affinity },
        ingredients = ingredients,
        results = results,
        enabled = false,
        auto_recycle = false,
        surface_conditions = { Rabbasca.only_underground(true) },
        category = "rabbasca-remote",
        subgroup = "rabbasca-remote",
        order = "f[planet]-"..affinity.."-b[materialized]-"..name,
    }
end

local function create_affinity_tech(planet, fluid, entities, lut)
  add_planet(planet, fluid, entities, lut)
  local tech_pre = {
    type = "technology",
    name = "rabbasca-warp-prep-"..planet,
    icons = Rabbasca.icons({
        { proto = data.raw["technology"]["planet-discovery-"..planet] or data.raw["planet"][planet], },
        { proto = data.raw["item"]["rabbasca-warp-stabilizer"] }
    }),
    prerequisites = { "rabbasca-warp-stabilizer" },
    localised_name = { "technology-name.rabbasca-warp-prep", { "space-location-name."..planet } },
    localised_description = { "technology-description.rabbasca-warp-prep" },
    effects = { },
    order = "r[warp-tech]-"..planet,
    research_trigger =
    {
        type = "scripted",
        trigger_description = { "rabbasca-extra.trigger-rabbasca-warp-prep", planet }
    }
  }
  local tech_flex = {
    type = "technology",
    name = "rabbasca-warp-anchoring-"..planet,
    hidden = true,
    prerequisites = { "rabbasca-warp-prep-"..planet },
    effects = { },
    localised_name = { "technology-name.rabbasca-warp-anchoring", planet },
    localised_description = { "technology-description.rabbasca-warp-anchoring", planet },
    research_trigger =
    {
        type = "scripted",
        trigger_description = { "rabbasca-extra.trigger-set-affinity", planet }
    }
  }
  mod_data.data.planets[planet].tech = tech_flex.name
  mod_data.data.planets[planet].tech_prep = tech_pre.name
  table.insert(data.raw["technology"]["rabbasca-warp-technology-analysis"].prerequisites, tech_pre.name)
  data:extend{
    tech_pre,
    tech_flex,
  }
end

create_affinity_tech("rabbasca", "harenic-lava", { "haronite", "rabbasca-energy-source" }, "__rabbasca-assets__/graphics/recolor/textures/lut-underground.png")
create_affinity_tech("vulcanus", "lava-hot", { "rabbasca-underground-tungsten-ore" }, "__rabbasca-assets__/graphics/recolor/textures/lut-underground-vulcanus.png")
create_affinity_tech("gleba", "water", nil, "__rabbasca-assets__/graphics/recolor/textures/lut-underground-gleba.png")
create_affinity_tech("fulgora", "fulgoran-sand", nil, "__rabbasca-assets__/graphics/recolor/textures/lut-underground-gleba.png")
create_affinity_tech("aquilo", "ice-rough", { "rabbasca-lithium-amide" }, "__rabbasca-assets__/graphics/recolor/textures/lut-underground-gleba.png")

table.insert(data.raw["technology"]["rabbasca-warp-prep-aquilo"].effects, { type = "unlock-recipe", recipe = "rabbasca-lithium-amide-fission"})

data:extend{
    make_materialize_recipe("carotenoid-ore", "item", "rabbasca",
        {{ type = "item", name = "carotenoid-ore", amount = 5, }},
        {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}),
    make_materialize_recipe("pentapod-egg", "item", "gleba",
        {{ type = "item", name = "pentapod-egg", amount = 1, }},
        {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}),
    make_materialize_recipe("yumako", "capsule", "gleba",
        {{ type = "item", name = "yumako", amount = 15, }},
        {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}),
    make_materialize_recipe("holmium-ore", "item", "fulgora",
        {{ type = "item", name = "holmium-ore", amount = 5, }},
        {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}),

    make_atmospheric_recipe("rabbasca", {{ type = "fluid", name = "petroleum-gas", amount = 20 }}),
    make_atmospheric_recipe("vulcanus", {{ type = "fluid", name = "sulfuric-acid", amount = 50 }}),
    make_atmospheric_recipe("aquilo", {{ type = "fluid", name = "fluorine", amount = 10 }})
}

data:extend{ 
    mod_data,
}