import React from 'react'
import PropTypes from 'prop-types'
// import Paper from '@material-ui/core/Paper'

class Recipe extends React.Component {
  static propTypes = {
    loadRecipe: PropTypes.func.isRequired,
    recipe: PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string.isRequired,
      ingredients: PropTypes.string.isRequired,
    }),
    location: PropTypes.shape({
      search: PropTypes.func,
    }).isRequired,
    match: PropTypes.shape({
      params: PropTypes.shape({
        recipeId: PropTypes.string,
      }),
    }).isRequired,
  }

  static defaultProps = {
    recipe: {},
  }

  componentDidMount() {
    const { loadRecipe, match } = this.props
    const { recipeId } = match.params
    loadRecipe(recipeId)
  }

  render() {
    const { recipe, noRecipe } = this.props
    if (!recipe && !recipe.name) {
      return null
    }
    if (noRecipe) {
      return (<div> {"We don't have a recipe like that"} </div>)
    }
    return (
      <div>
        {recipe.name}
      </div>
    )
  }
}

export default Recipe

Recipe.propTypes = {
  recipe: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string.isRequired,
    ingredients: PropTypes.string.isRequired,
  }),
  noRecipe: PropTypes.bool.isRequired,
}
