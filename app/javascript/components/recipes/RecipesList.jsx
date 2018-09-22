import React from 'react'
import queryString from 'query-string'
import PropTypes from 'prop-types'

class RecipesList extends React.Component {
  static propTypes = {
    loadRecipes: PropTypes.func.isRequired,
    selectedRecipes: PropTypes.arrayOf(PropTypes.shape({})),
    recipesLoaded: PropTypes.bool,
    startingTagId: PropTypes.string.isRequired,
    history: PropTypes.shape({
      push: PropTypes.func,
    }).isRequired,
    location: PropTypes.shape({
      search: PropTypes.func,
    }).isRequired,
  }

  static defaultProps = {
    recipesLoaded: false,
    selectedRecipes: [],
  }

  componentDidMount() {
    const { loadRecipes, startingTagId } = this.props
    loadRecipes(startingTagId)
  }

  render() {
    const { recipesLoaded } = this.props

    if (!recipesLoaded) {
      return null
    }
    return (
      <div>
        Recipes Loaded
      </div>
    )
  }
}

export default RecipesList
