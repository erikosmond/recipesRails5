import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import RecipeDropdown from 'components/recipes/RecipeDropdown'

import { loadRecipeOptions } from 'bundles/recipes'

export default withRouter(connect(
  state => ({
    recipeOptions: state.recipesReducer.recipeOptions,
  }),
  {
    loadRecipeOptions,
  },
)(RecipeDropdown))
