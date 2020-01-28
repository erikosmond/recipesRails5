import React from 'react'
import PropTypes from 'prop-types'
import RecipeForm from './RecipeForm'

class RecipeFormSkeleton extends React.Component {
    static propTypes = {
      handleRecipeSubmit: PropTypes.func.isRequired,
      ingredientOptions: PropTypes.arrayOf(PropTypes.shape({
          id: PropTypes.number,
          name: PropTypes.string,
      }))
    }
  
    static defaultProps = {
      ingredientOptions: [],
    }

    submit = values => {
    // send the values to the store
    const {handleRecipeSubmit} = this.props
    handleRecipeSubmit(values)
  }
  render() {
    return <RecipeForm onSubmit={this.submit} />
  }
}

export default RecipeFormSkeleton