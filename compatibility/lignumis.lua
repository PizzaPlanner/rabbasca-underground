if not mods["lignumis"] then return end
if not settings.startup["rabbasca-ug-target-lignumis"].value then return end

Rabbasca.Stabilizer.add_location{
    planet = "lignumis",
    filler_tile = "volcanic-folds-warm",
    autoplace_entities = { },
    anomaly_replace_entities = { 
        { type = "resource", name = "peat", probability = 0.0024, richness = 190, floor = "lowland-brown-blubber" },
    },
    lut = "__rabbasca-assets__/graphics/recolor/textures/lut-underground-vulcanus.png",
}