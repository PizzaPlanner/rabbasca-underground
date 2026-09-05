data:extend {
    {
        type = "furnace",
        name = "rabbasca-hellvent",
        icons = { { icon = "__space-age__/graphics/icons/fluorine-vent.png", icon_size = 64 } },
        flags = { "placeable-player", "not-repairable", "not-deconstructable", "no-logistic-connection" },
        collision_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        result_inventory_size = 10,
        source_inventory_size = 1,
        crafting_speed = 1,
        crafting_categories = { "rabbasca-psychosis" },
        energy_usage = "10W",
        energy_source = { type = "void" },
        max_health = 666,
        placeable_by = { count = 1, item = "rabbasca-hellvent" },
        production_health_effect = {
            producing = 33.33 / second,
            not_producing = -33.33 / second,
            damage_type = "rabbasca-psychic"
        },
        graphics_set = {
            working_visualisations = {
                {
                    count = 1,
                    render_layer = "smoke",
                    animation = util.sprite_load("__space-age__/graphics/entity/lithium-brine/smoke-1",
                        {
                            priority = "extra-high",
                            frame_count = 64,
                            animation_speed = 0.35,
                            draw_as_glow = true,
                            tint = { 0.95, 0.13, 0.05 },
                            scale = 0.75,
                            shift = { 0, -0.23 }
                        })
                },
                {
                    count = 1,
                    render_layer = "smoke",
                    animation = util.sprite_load("__space-age__/graphics/entity/lithium-brine/smoke-2",
                        {
                            priority = "extra-high",
                            frame_count = 64,
                            animation_speed = 0.35,
                            draw_as_glow = true,
                            tint = { 0.82, 0.37, 0.05, 0.74 },
                            scale = 0.75,
                            shift = { 0, -0.23 }
                        })
                },
                {
                    count = 1,
                    render_layer = "smoke",
                    animation = {
                        filename = "__space-age__/graphics/entity/fluorine-vent/fluorine-vent-gas-outer.png",
                        frame_count = 47,
                        line_length = 16,
                        width = 90,
                        height = 188,
                        animation_speed = 0.5,
                        shift = util.by_pixel(-2, 24 - 152),
                        scale = 1.0,
                        tint = util.multiply_color({ r = 0.44, g = 0.31, b = 0.61 }, 0.2)
                    }
                },
                {
                    count = 1,
                    render_layer = "smoke",
                    animation = {
                        filename = "__space-age__/graphics/entity/fluorine-vent/fluorine-vent-gas-inner.png",
                        frame_count = 47,
                        line_length = 16,
                        width = 40,
                        height = 84,
                        animation_speed = 0.5,
                        shift = util.by_pixel(0, 24 - 78),
                        scale = 1.5,
                        draw_as_glow = true,
                        tint = util.multiply_color({ 0.85, 0, 0.53 }, 0.3),
                    }
                }
            },
            default_recipe_tint = { primary = { 0.5, 1, 0 } },
            idle_animation = {
                layers =
                {
                    util.sprite_load("__rabbasca-assets__/graphics/recolor/entities/hellvent",
                        {
                            priority = "extra-high",
                            frame_count = 1,
                            scale = 0.7,
                        })
                }
            },
            always_draw_idle_animation = true
        },
    },
    {
        name = "rabbasca-hellvent",
        type = "item",
        stack_size = 200,
        icons = { { icon = "__space-age__/graphics/icons/fluorine-vent.png", icon_size = 64 } },
        subgroup = "rabbasca-security",
        order = "x[sanity-restore]",
        spoil_ticks = 1 * minute,
        spoil_to_trigger_result = {
            items_per_trigger = 10,
            trigger = {
                type = "direct",
                action_delivery =
                {
                    type = "instant",
                    source_effects = {
                        type = "create-entity",
                        entity_name = "rabbasca-small-insanity-crawler",
                        as_enemy = true,
                    }
                }
            }
        },
        place_result = "rabbasca-hellvent"
    },
    {
        type = "recipe",
        name = "rabbasca-hellvent",
        enabled = false,
        energy_required = 3,
        allow_productivity = false,
        allow_quality = false,
        auto_recycle = false,
        hide_from_player_crafting = false,
        ingredients = {
            { type = "item", name = "rabbasca-contained-imagination", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1 }
        },
        results = {
            { type = "item", name = "rabbasca-hellvent",              amount = 1, always_fresh = true },
            { type = "item", name = "rabbasca-contained-imagination", amount = 1, ignored_by_stats = 1, ignored_by_productivity = 1 }
        },
        main_product = "rabbasca-hellvent",
        categories = { "crafting" }
    },
}
