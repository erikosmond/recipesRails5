import React from 'react'
import PropTypes from 'prop-types'
import StyledSelect from '../styled/StyledSelect'

class RecipeDropdown extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      selectedOption: null,
    }
  }

  componentDidMount() {
    const { loadIngredientOptions } = this.props
    loadIngredientOptions()
  }

  handleChange = (selectedOption) => {
    const { history } = this.props
    this.setState({ selectedOption })
    history.push(`/tags/${selectedOption.value}/recipes`)
  }

  render() {
    const { selectedOption } = this.state
    const { ingredientOptions } = this.props
    const options = ingredientOptions || []
    return (
      <StyledSelect
        value={selectedOption}
        onChange={this.handleChange}
        options={options}
        placeholder="Ingredients"
        isSearchable
        isClearable
      />
    )
  }
}

export default RecipeDropdown

RecipeDropdown.propTypes = {
  loadIngredientOptions: PropTypes.func.isRequired,
  ingredientOptions: PropTypes.shape.isRequired,
  history: PropTypes.shape({
    push: PropTypes.func,
  }).isRequired,
}
