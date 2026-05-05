Rabbasca.Stabilizer.add_location{
    planet = "rabbasca",
    filler_tile = "harenic-lava",
    autoplace_entities = { "rabbasca-energy-source" },
    anomaly_replace_entities = { 
        { type = "resource", name = "haronite", probability = 0.0063, richness = 165, floor = "volcanic-folds-warm" },
    },
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-rabbasca.png",
    min_stay = 60,
    max_stay = 75,
}
Rabbasca.Stabilizer.add_location{
    planet = "vulcanus",
    filler_tile = "lava-hot",
    anomaly_replace_entities = { 
        { type = "resource", name = "tungsten-ore", probability = 0.0011, richness = 290, floor = "volcanic-cracks-hot" }, 
    },
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-vulcanus.png",
    min_stay = 50,
    max_stay = 60,
}
Rabbasca.Stabilizer.add_location{
    planet = "gleba",
    filler_tile = "wetland-light-green-slime",
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-gleba.png",
    anomaly_replace_entities = { 
        { type = "resource", name = "rabbasca-yumako-mashup", probability = 0.0015, richness = 582, floor = "lowland-brown-blubber" }, 
    },
    min_stay = 50,
    max_stay = 70,
}
Rabbasca.Stabilizer.add_location{
    planet = "fulgora",
    filler_tile = "fulgoran-sand",
    anomaly_replace_entities = { 
        { type = "resource", name = "rabbasca-holmium-ore", probability = 0.06, richness = 21, floor = "fulgoran-rock" }, 
    },
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-fulgora.png",
    min_stay = 40,
    max_stay = 60,
}

Rabbasca.Stabilizer.add_location{
    planet = "aquilo",
    filler_tile = "ice-rough",
    -- autoplace_entities = { "rabbasca-lithium-amide" },
    anomaly_replace_entities = { 
        { type = "resource", name = "rabbasca-lithium-amide", probability = 0.008, richness = 200, floor = "volcanic-smooth-stone" }, 
    },
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-aquilo.png",
    min_stay = 30,
    max_stay = 55,
}

data:extend{
    Rabbasca.Stabilizer.make_atmospheric_recipe("rabbasca", {{ type = "fluid", name = "petroleum-gas", amount = 20 }}),
    Rabbasca.Stabilizer.make_atmospheric_recipe("vulcanus", {{ type = "fluid", name = "sulfuric-acid", amount = 50 }}),
    Rabbasca.Stabilizer.make_atmospheric_recipe("aquilo", {{ type = "fluid", name = "fluorine", amount = 10 }})
}