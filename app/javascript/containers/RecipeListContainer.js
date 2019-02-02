import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import RecipeList from 'components/recipes/RecipeList'

import {
  loadRecipes,
  loadTagInfo,
  handleFilter,
  loadAllTags,
  clearFilters,
  updateRecipeTag,
} from 'bundles/recipes'

export default withRouter(connect(
  state => ({
    selectedRecipes: state.recipesReducer.selectedRecipes,
    recipesLoaded: state.recipesReducer.recipesLoaded,
    selectedTag: state.recipesReducer.selectedTag,
    noRecipes: state.recipesReducer.noRecipes,
    startingTagId: state.recipesReducer.startingTagId,
    loading: state.recipesReducer.loading,
    visibleFilterTags: state.recipesReducer.visibleFilterTags,
    allTags: state.recipesReducer.allTags,
    tagGroups: state.recipesReducer.tagGroups,
    allTagTypes: state.recipesReducer.allTagTypes,
    tagsByType: state.recipesReducer.tagsByType,
    priorities: state.recipesReducer.priorities,
    ratings: state.recipesReducer.ratings,
  }),
  {
    loadRecipes,
    loadAllTags,
    loadTagInfo,
    handleFilter,
    clearFilters,
    updateRecipeTag,
  },
)(RecipeList))
