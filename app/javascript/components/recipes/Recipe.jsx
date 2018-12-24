import React from 'react'
import PropTypes from 'prop-types'
import RecipeProperties from 'components/recipes/RecipeProperties'
import RecipeInstructions from 'components/recipes/RecipeInstructions'
import RecipeDescription from 'components/recipes/RecipeDescription'
import { allIngredients } from 'services/recipes'
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
        <RecipeProperties title="Ingredients" tags={allIngredients(recipe)} />
        <RecipeInstructions recipe={recipe} />
        <RecipeDescription recipe={recipe} />
        <RecipeProperties title="Sources" tags={recipe.sources} />
        <RecipeProperties title="Menus" tags={recipe.menus} />
        <RecipeProperties title="Preparations" tags={recipe.preparations} />
        <RecipeProperties title="Priorities" tags={recipe.priorities} />
        <RecipeProperties title="Ratings" tags={recipe.ratings} />
        <RecipeProperties title="Vessels" tags={recipe.vessels} />
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
