local settings = require("scripts.sanity")

local function time(s)
  return string.format("%i", s / 60)
end

data:extend {
Rabbasca.make_trigger_item({
  name = "rabbasca-psychosis",
  icon = "__rabbasca-assets__/graphics/recolor/icons/sanity-mote.png",
  icon_size = 76,
  hidden = false,
  hidden_in_factoriopedia = false,
  stack_size = 10000,
  custom_tooltip_fields = {
    { name = { "tooltip.rabbasca-psychosis-duration-new" }, value = { "tooltip-value.rabbasca-psychosis-duration-new", time(settings.INITIAL_PANIC_DURATION), time(settings.INITIAL_PANIC_DURATION * settings.DURATION_MULT_HAT) } },
    { name = { "tooltip.rabbasca-psychosis-duration-add" }, value = { "tooltip-value.rabbasca-psychosis-duration-add", time(settings.EXTEND_PANIC_DURATION), time(settings.EXTEND_PANIC_DURATION * settings.DURATION_MULT_HAT) } },
    { name = { "tooltip.rabbasca-psychosis-affinity" }, value = { "tooltip-value.rabbasca-psychosis-affinity" } }
  },
}, "rabbasca_on_sanity_attack"),
}

data.raw["item"]["rabbasca-psychosis"].flags = { "ignore-spoil-time-modifier" }


data:extend{
{
  type = "sticker",
  name = "rabbasca-insanity-sticker-debuff",
  duration_in_ticks = settings.MAX_PANIC_DURATION,
  -- force_visibility = "ally",
  render_layer = "air-object",
  flags = {"not-on-map"},
  hidden = true,
  single_particle = true,
  animation = {
    layers = { 
      Rabbasca.animation_layer("__rabbasca-assets__/graphics/recolor/textures/sani", { tint = { 0.83, 0, 0.72 }, scale = 0.16, draw_as_glow = true, blend_mode = "additive", shift = util.by_pixel(-8,-54) }),
      Rabbasca.animation_layer("__rabbasca-assets__/graphics/recolor/textures/sani", { tint = { 0.33, 0, 1 },    scale = 0.14, draw_as_glow = true, blend_mode = "additive", shift = util.by_pixel(8,-56), frame_sequence = { 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24 } })
    }
  },
  update_effects = {
    { 
      time_cooldown = settings.DEFAULT_BUFF_INTERVAL,
      initial_time_cooldown = 5 * 60,
      effect = {
        type = "script",
        effect_id = "rabbasca_on_insanity_tick",
      }
    }
  }
},
{
  type = "sticker",
  name = "rabbasca-crawler-sticker-debuff",
  duration_in_ticks = 5 * second,
  target_movement_modifier_from = 0.33,
  target_movement_modifier_to = 1,
  ground_target = true,
  flags = {"not-on-map"},
  hidden = true,
  single_particle = true,
  animation =
    util.sprite_load("__space-age__/graphics/sticker/jellynut-speed/whirl_front",
      {
        priority = "high",
        frame_count = 50,
        scale = 0.5,
        animation_speed = 0.5,
        tint = { 1, 0, 0.3 },
        shift = util.by_pixel(0,16)
      }
    )
}
}
data:extend{ util.merge { data.raw["sticker"]["rabbasca-insanity-sticker-debuff"], { name = "rabbasca-insanity-sticker-buff", animation = { layers = { { tint = { 0, 0.83, 0.77 } },{} }} } } }
