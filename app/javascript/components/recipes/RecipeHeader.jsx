import React from 'react'
import PropTypes from 'prop-types'
import RecipeDropdown from './RecipeDropdown'
import IngredientDropdown from './IngredientDropdown'

const RecipeHeader = (props) => {
  const {
    loadRecipeOptions,
    recipeOptions,
    loadIngredientOptions,
    ingredientOptions,
    history,
  } = props
  return (
    <div>
      <RecipeDropdown
        recipeOptions={recipeOptions}
        loadRecipeOptions={loadRecipeOptions}
        history={history}
      />
      <IngredientDropdown
        ingredientOptions={ingredientOptions}
        loadIngredientOptions={loadIngredientOptions}
        history={history}
      />
    </div>
  )
}

export default RecipeHeader

RecipeHeader.propTypes = {
  loadRecipeOptions: PropTypes.func.isRequired,
  recipeOptions: PropTypes.arrayOf.isRequired,
  loadIngredientOptions: PropTypes.func.isRequired,
  ingredientOptions: PropTypes.arrayOf.isRequired,
  history: PropTypes.shape({
    push: PropTypes.func,
  }).isRequired,
}
