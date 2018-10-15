import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import RecipesList from 'components/recipes/RecipesList'

import { loadRecipes, initialLoadOccurred } from 'bundles/recipes'

export default withRouter(connect(
  state => ({
    selectedRecipes: state.recipesReducer.selectedRecipes,
    recipesLoaded: state.recipesReducer.recipesLoaded,
    selectedTagName: state.recipesReducer.selectedTagName,
    initialLoad: state.recipesReducer.initialLoad,
  }),
  {
    loadRecipes,
    initialLoadOccurred,
  },
)(RecipesList))
