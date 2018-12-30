export function selectedFilterService(filterId, checked, state) {
  if (Array.isArray(state.selectedFilters)) {
    const idIndex = state.selectedFilters.indexOf(filterId)
    if (checked && idIndex === -1) {
      return [...state.selectedFilters, filterId]
    }
    if (!checked && idIndex > -1) {
      const a = [...state.selectedFilters]
      a.splice(idIndex, 1)
      return a
    }
    return [...state.selectedFilters]
  }
  if (checked) {
    return [filterId]
  }
  return []
}

export function visibleFilterService(selectedRecipes = [], allTags = []) {
  const visibleFilters = []
  selectedRecipes.forEach((r) => {
    if (!r.hidden) {
      const ids = Object.keys(r.tagIds) || []
      ids.forEach((id) => {
        const i = parseInt(id, 10)
        visibleFilters.push([i, allTags[i].label])
        // some of the wrong tags are displayed after this function is run
      })
    }
  })
  return visibleFilters
}

export function selectedRecipeService(selectedFilters, state) {
  return state.selectedRecipes.map(r => recipeReducer(r, selectedFilters))
}

function recipeReducer(recipe, filters) {
  let visible = true
  filters.forEach((f) => {
    visible = visible && recipe.tagIds[f]
  })
  return {
    ...recipe,
    hidden: !visible,
  }
}
