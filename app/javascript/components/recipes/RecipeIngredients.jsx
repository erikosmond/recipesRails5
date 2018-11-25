import React from 'react'
import PropTypes from 'prop-types'
import Typography from '@material-ui/core/Typography'
import IngredientListItem from 'components/recipes/IngredientListItem'


const RecipeIngredients = (props) => {
  const { recipe } = props

  return (
    <div>
      <Typography paragraph variant="body2">
        Ingredients:
      </Typography>
      <ul>
        {Object.values(recipe.ingredients).map(ingredient => (
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
