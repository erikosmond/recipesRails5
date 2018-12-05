import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import RecipeList from 'components/recipes/RecipeList'

import { loadRecipes, loadTagInfo } from 'bundles/recipes'

export default withRouter(connect(
  state => ({
    selectedRecipes: state.recipesReducer.selectedRecipes,
    recipesLoaded: state.recipesReducer.recipesLoaded,
    selectedTag: state.recipesReducer.selectedTag,
    noRecipes: state.recipesReducer.noRecipes,
    startingTagId: state.recipesReducer.startingTagId,
    loading: state.recipesReducer.loading,
  }),
  {
    loadRecipes,
    loadTagInfo,
  },
)(RecipeList))
