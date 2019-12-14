import { connect } from 'react-redux'
import { withRouter } from 'react-router-dom'

import CommentModal from 'components/recipes/CommentModal'

import { loadRecipe } from 'bundles/recipes'

export default withRouter(connect(
  state => ({
    recipe: state.recipesReducer.recipe,
    noRecipe: state.recipesReducer.noRecipe,
  }),
  {
    loadRecipe,
  },
)(CommentModal))
