import React from 'react'
import Select from 'react-select'
import PropTypes from 'prop-types'
import styled from 'styled-components'

const StyledSelect = styled(Select)`
  max-width: 30%;
`

class RecipeDropdown extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      selectedOption: null,
    }
  }

  componentDidMount() {
    const { loadRecipeOptions } = this.props
    loadRecipeOptions()
  }

  handleChange = (selectedOption) => {
    const { history } = this.props
    this.setState({ selectedOption })
    history.push(`/recipes/${selectedOption.value}`)
  }

  render() {
    const { selectedOption } = this.state
    const { recipeOptions } = this.props
    const options = recipeOptions || []
    return (
      <StyledSelect
        value={selectedOption}
        onChange={this.handleChange}
        options={options}
        placeholder="Recipes"
        isSearchable
      />
    )
  }
}

export default RecipeDropdown

RecipeDropdown.propTypes = {
  loadRecipeOptions: PropTypes.func.isRequired,
  loadRecipe: PropTypes.func.isRequired,
  recipeOptions: PropTypes.shape.isRequired,
  history: PropTypes.shape({
    push: PropTypes.func,
  }).isRequired,
}
