Rabbasca.Stabilizer.add_location{
    planet = "rabbasca",
    filler_tile = "harenic-lava",
    autoplace_entities = { "haronite", "rabbasca-energy-source" },
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground.png",
    min_stay = 60,
    max_stay = 75,
}
Rabbasca.Stabilizer.add_location{
    planet = "vulcanus",
    filler_tile = "lava-hot",
    autoplace_entities = { "rabbasca-underground-tungsten-ore" },
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-vulcanus.png",
    min_stay = 50,
    max_stay = 60,
}
Rabbasca.Stabilizer.add_location{
    planet = "gleba",
    filler_tile = "water",
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-gleba.png",
    min_stay = 50,
    max_stay = 70,
}
Rabbasca.Stabilizer.add_location{
    planet = "fulgora",
    filler_tile = "fulgoran-sand",
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-gleba.png",
    min_stay = 40,
    max_stay = 60,
}

Rabbasca.Stabilizer.add_location{
    planet = "aquilo",
    filler_tile = "ice-rough",
    autoplace_entities = { "rabbasca-lithium-amide" },
    lut_texture = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-gleba.png",
    permanent_recipes = { "rabbasca-lithium-amide-fission" },
    min_stay = 30,
    max_stay = 55,
}

data:extend{
    Rabbasca.Stabilizer.make_pylon_recipe("carotenoid-ore", "item", "rabbasca",
        {{ type = "item", name = "carotenoid-ore", amount = 11, }},
        {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}),
    Rabbasca.Stabilizer.make_pylon_recipe("pentapod-egg", "item", "gleba",
        {{ type = "item", name = "pentapod-egg", amount = 1, }},
        {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}),
    Rabbasca.Stabilizer.make_pylon_recipe("yumako", "capsule", "gleba",
        {{ type = "item", name = "yumako", amount = 15, }},
        {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}),
    Rabbasca.Stabilizer.make_pylon_recipe("holmium-ore", "item", "fulgora",
        {{ type = "item", name = "holmium-ore", amount = 3, }},
        {{ type = "item", name = "rabbasca-warp-matrix", amount = 1 }}),

    Rabbasca.Stabilizer.make_atmospheric_recipe("rabbasca", {{ type = "fluid", name = "petroleum-gas", amount = 20 }}),
    Rabbasca.Stabilizer.make_atmospheric_recipe("vulcanus", {{ type = "fluid", name = "sulfuric-acid", amount = 50 }}),
    Rabbasca.Stabilizer.make_atmospheric_recipe("aquilo", {{ type = "fluid", name = "fluorine", amount = 10 }})
}