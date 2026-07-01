Rabbasca.Stabilizer.add_location{
    planet = "rabbasca",
    filler_tile = "harenic-lava",
    autoplace_entities = { "rabbasca-energy-source" },
    anomaly_replace_entities = { 
        { type = "resource", name = "haronite", probability = 0.0063, richness = 330, floor = "volcanic-folds-warm" },
    },
    lut = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-rabbasca.png",
    unlock_on_first_arrival = { "rabbasca-plastic-from-petroleum-gas" }
}
Rabbasca.Stabilizer.add_location{
    planet = "vulcanus",
    filler_tile = "lava-hot",
    anomaly_replace_entities = { 
        { type = "resource", name = "tungsten-ore", probability = 0.0011, richness = 510, floor = "volcanic-cracks-hot" }, 
    },
    lut = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-vulcanus.png",
}
Rabbasca.Stabilizer.add_location{
    planet = "gleba",
    filler_tile = "wetland-light-green-slime",
    lut = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-gleba.png",
    anomaly_replace_entities = { 
        { type = "resource", name = "rabbasca-yumako-mashup", probability = 0.0015, richness = 825, floor = "lowland-brown-blubber" }, 
    },
}
Rabbasca.Stabilizer.add_location{
    planet = "fulgora",
    filler_tile = "fulgoran-sand",
    anomaly_replace_entities = { 
        { type = "resource", name = "rabbasca-holmium-ore", probability = 0.04, richness = 69, floor = "fulgoran-rock" }, 
    },
    lut = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-fulgora.png",
}

Rabbasca.Stabilizer.add_location{
    planet = "aquilo",
    filler_tile = "ice-rough",
    -- autoplace_entities = { "rabbasca-lithium-amide" },
    anomaly_replace_entities = { 
        { type = "resource", name = "rabbasca-lithium-amide", probability = 0.008, richness = 410, floor = "volcanic-smooth-stone" }, 
    },
    lut = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-aquilo.png",
}

data:extend{
    Rabbasca.Stabilizer.make_atmospheric_recipe("rabbasca", {{ type = "fluid", name = "petroleum-gas", amount = 30 }}),
    Rabbasca.Stabilizer.make_atmospheric_recipe("vulcanus", {{ type = "fluid", name = "sulfuric-acid", amount = 55 }}),
    Rabbasca.Stabilizer.make_atmospheric_recipe("aquilo", {{ type = "fluid", name = "fluorine", amount = 50 }}),
    Rabbasca.Stabilizer.make_atmospheric_recipe("fulgora", {{ type = "fluid", name = "heavy-oil", amount = 25 }}),
    Rabbasca.Stabilizer.make_atmospheric_recipe("gleba", {{ type = "fluid", name = "water", amount = 100 }})
}