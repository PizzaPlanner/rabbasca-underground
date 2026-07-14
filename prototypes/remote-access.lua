local remote_access = {
    name = "rabbasca-remote-access-chest",
    icon = "__rabbasca-assets__/graphics/recolor/icons/nearby-access.png",
    icon_size = 64,
    type = "proxy-container",
    circuit_wire_max_distance = 90,
    minable = { result = "rabbasca-remote-access-chest", count = 1, mining_time = 1 },
    placeable_by = { item = "rabbasca-remote-access-chest", count = 1 },
    flags = { "placeable-player", "player-creation" },
    next_upgrade = nil,
    deconstruction_alternative = nil,
    draw_inventory_content = true,
    max_health = 100,
    picture = table.deepcopy(data.raw["linked-container"]["linked-chest"].picture),
    collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
    selection_box = { { -0.5, -0.5 }, { 0.5, 0.5 } },
    surface_conditions = { { property = "gravity", min = 1 } },
}
remote_access.picture.layers[1].filename = "__rabbasca-assets__/graphics/recolor/entities/nearby-access.png"

data:extend{ 
    remote_access,
    {
        type = "recipe",
        name = "rabbasca-remote-access-chest",
        enabled = false,
        energy_required = 3,
        ingredients = {
            { type = "item", name = "rabbasca-warpfield-excitement-rod",  amount = 2 },
            { type = "item", name = "rabbasca-warp-core",  amount = 5 },
            { type = "item", name = "steel-chest",  amount = 1 },
        },
        results = { { type = "item", name = "rabbasca-remote-access-chest", amount = 1 } },
        surface_conditions = { Rabbasca.only_underground(true) },
        categories = { "crafting" }
    },
    {
        type = "item",
        name = "rabbasca-remote-access-chest",
        icon = "__rabbasca-assets__/graphics/recolor/icons/nearby-access.png",
        icon_size = 64,
        place_result = "rabbasca-remote-access-chest",
        stack_size = 50,
        weight = 100 * kg,
        subgroup = "storage",
        order = "a[items]-x[remote-access]",
    },
}