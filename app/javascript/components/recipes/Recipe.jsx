import React from 'react'
import PropTypes from 'prop-types'
import RecipeIngredients from 'components/recipes/RecipeIngredients'
import RecipeInstructions from 'components/recipes/RecipeInstructions'
import RecipeDescription from 'components/recipes/RecipeDescription'
// import Paper from '@material-ui/core/Paper'

class Recipe extends React.Component {
  static propTypes = {
    loadRecipe: PropTypes.func.isRequired,
    recipe: PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string.isRequired,
      ingredients: PropTypes.string.isRequired,
    }),
    location: PropTypes.shape().isRequired,
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

  componentWillReceiveProps(nextProps) {
    if (nextProps.location !== this.props.location) {
      const { recipeId } = nextProps.match.params
      if (recipeId) {
        nextProps.loadRecipe(recipeId)
      }
    }
  }

  render() {
    const { recipe, noRecipe } = this.props
    if (!recipe || !recipe.name) {
      return null
    }
    if (noRecipe) {
      return (
        <div>
          <div> {"We don't have a recipe like that"} </div>
        </div>
      )
    }
    return (
      <div>
        <h2>{recipe.name}</h2>
        <RecipeIngredients recipe={recipe} />
        <RecipeInstructions recipe={recipe} />
        <RecipeDescription recipe={recipe} />
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
