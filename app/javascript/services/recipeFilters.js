export function selectedFilterService(id, checked, state) {
  console.log(id)
  console.log(checked)
  console.log(state)
  // return (ingredients.concat(ingredientTypes)).concat(ingredientFamilies)
}

export function selectedRecipeService(id, checked, state) {
  console.log(id)
  console.log(checked)
  console.log(state)
  return state.selectedRecipes
  // return (ingredients.concat(ingredientTypes)).concat(ingredientFamilies)
}
