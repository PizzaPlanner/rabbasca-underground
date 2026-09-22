local imaginary_items = { 
    ["rabbasca-hellvent"] = true, 
    ["rabbasca-contained-imagination"] = true, 
    ["rabbasca-rampant-imagination"] = true, 
    ["rabbasca-imaginary-science-pack"] = true,
    ["rabbasca-psychosis"] = true,
}

local valid_categories = { 
    ["rabbasca-psychosis-manual"] = true,
    ["rabbasca-psychosis"] = true,
}

local whitelisted_recipes = {
    ["rabbasca-tinfoil-hat"] = true, -- normal recipe using rampant imagination
    ["rabbasca-rampant-imagination"] = true, -- made in recycler
}

local function imaginary_categories_only(categories)
    for _, cat in pairs(categories) do
        if not valid_categories[cat] then return false end
    end
    return true
end

for _, recipe in pairs(data.raw["recipe"]) do
    local incompatible = false
    for _, ingred in pairs(recipe.ingredients or { }) do
        if imaginary_items[ingred.name] and not imaginary_categories_only(recipe.categories) then
            incompatible = not whitelisted_recipes[recipe.name]
        end
    end
    if incompatible then
        PlanetsLib.excise_recipe_from_tech_tree(recipe.name)
        recipe.enabled = false
        recipe.hidden = true
        recipe.hidden_in_factoriopedia = true
    end
end