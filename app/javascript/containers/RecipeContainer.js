import { connect } from 'react-redux'
// import { withRouter } from 'react-router-dom'

import Recipe from 'components/recipes/Recipe'

import { loadRecipe } from 'bundles/recipes'

// export default withRouter(connect(
export default connect(
  state => ({
    recipe: state.recipesReducer.recipe,
    noRecipe: state.recipesReducer.noRecipe,
  }),
  {
    loadRecipe,
  },
)(Recipe) // )
