import React from 'react'
import PropTypes from 'prop-types'
import styled from 'styled-components'
import HeaderDropdown from './HeaderDropdown'

const StyledHeader = styled.div`
  width: 100%;
  position: fixed;
  top: 0px;
  background-color: white;
  z-index: 1;
`

const RecipeHeader = (props) => {
  const {
    loadRecipeOptions,
    recipeOptions,
    loadIngredientOptions,
    ingredientOptions,
    categoryOptions,
    history,
  } = props

  const updateTags = (selectedOption) => {
    history.push(`/tags/${selectedOption}/recipes`)
  }

  const updateRecipes = (selectedOption) => {
    history.push(`/recipes/${selectedOption}`)
  }

  return (
    <StyledHeader>
      <HeaderDropdown
        dropdownOptions={recipeOptions}
        loadOptions={loadRecipeOptions}
        placeholder="Recipes"
        updateHistory={updateRecipes}
      />
      <HeaderDropdown
        dropdownOptions={ingredientOptions}
        loadOptions={loadIngredientOptions}
        placeholder="Ingredients"
        updateHistory={updateTags}
      />
      <HeaderDropdown
        dropdownOptions={categoryOptions}
        loadOptions={loadIngredientOptions}
        placeholder="More"
        updateHistory={updateTags}
      />
    </StyledHeader>
  )
}

export default RecipeHeader

RecipeHeader.propTypes = {
  loadRecipeOptions: PropTypes.func.isRequired,
  recipeOptions: PropTypes.arrayOf(PropTypes.shape({name: PropTypes.string, id: PropTypes.number})),
  loadIngredientOptions: PropTypes.func.isRequired,
  ingredientOptions: PropTypes.arrayOf(PropTypes.shape({name: PropTypes.string, id: PropTypes.number})),
  categoryOptions: PropTypes.arrayOf(PropTypes.shape({name: PropTypes.string, id: PropTypes.number})),
  history: PropTypes.shape({
    push: PropTypes.func,
  }).isRequired,
}

RecipeHeader.defaultProps = {
  recipeOptions: [],
  ingredientOptions: [],
  categoryOptions: [],
}
