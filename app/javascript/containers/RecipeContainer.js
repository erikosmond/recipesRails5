import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import RecipeSkeleton from 'components/recipes/RecipeSkeleton'

import { loadRecipe } from 'bundles/recipes'

export default withRouter(connect(
  state => ({
    recipe: state.recipesReducer.recipe,
    noRecipe: state.recipesReducer.noRecipe,
  }),
  {
    loadRecipe,
  },
)(RecipeSkeleton))
