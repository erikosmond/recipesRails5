export function allIngredients(recipe) {
  const ingredients = getList(recipe.ingredients)
  const ingredientTypes = getList(recipe.ingredienttypes)
  const ingredientFamilies = getList(recipe.ingredientfamilies)
  return (ingredients.concat(ingredientTypes)).concat(ingredientFamilies)
}

function getList(ingredients) {
  if (ingredients instanceof Object) {
    return Object.values(ingredients)
  } else if (ingredients instanceof Array) {
    return ingredients
  }
  return []
}
