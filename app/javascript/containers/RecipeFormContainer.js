import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import RecipeForm from 'components/recipes/Recipe'

import { loadRecipeFormData } from 'bundles/recipes'

export default withRouter(connect(
  state => ({
    recipe: state.recipesReducer.recipe,
    formData: state.recipesReducer.formData,
  }),
  {
    loadRecipeFormData,
  },
)(RecipeForm))
