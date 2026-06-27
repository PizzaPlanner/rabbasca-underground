data:extend {
{
    name = "rabbasca-warp-overlay-dummy",
    type = "temporary-container",
    icon = data.raw["item"]["no-item"].icon,
    hidden = true,
    flags = { "placeable-off-grid", "not-in-kill-statistics", "placeable-neutral" },
    collision_mask = { layers = { } },
    collision_box = {{0, 0}, {0, 0}},
    destroy_on_empty = false,
    time_to_live = 1,
    inventory_size = 1,
    created_effect = {
        type = "direct",
        action_delivery = { type = "instant", 
        source_effects = {
        {
            type = "camera-effect",
            duration = 180,
            ease_in_duration = 70,
            ease_out_duration = 70,
            delay = 0,
            strength = 50,
            full_strength_max_distance = 400,
            max_distance = 1600
            
        },
    }}
    }
}
}