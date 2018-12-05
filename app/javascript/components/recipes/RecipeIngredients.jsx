import React from 'react'
import PropTypes from 'prop-types'
import Typography from '@material-ui/core/Typography'
import IngredientListItem from 'components/recipes/IngredientListItem'
import { allIngredients } from 'services/recipes'


const RecipeIngredients = (props) => {
  const { recipe } = props
  // const ingredients = recipe.ingredients || []
  // const ingredientTypes = recipe.ingredienttypes || []
  // const ingredientFamilies = recipe.ingredientfamilies || []
  // const allIngredients = (ingredients.concat(ingredientTypes)).concat(ingredientFamilies)
  return (
    <div>
      <Typography paragraph variant="body2">
        Ingredients:
      </Typography>
      <ul>
        {Object.values(allIngredients(recipe)).map(ingredient => (
          <IngredientListItem key={ingredient.id} ingredient={ingredient} />
        ))}
      </ul>
    </div>
  )
}

RecipeIngredients.propTypes = {
  recipe: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string.isRequired,
    ingredients: PropTypes.string.isRequired,
  }).isRequired,
}

export default RecipeIngredients
