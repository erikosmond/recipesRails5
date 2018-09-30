import React from 'react'
import PropTypes from 'prop-types'
import RecipeListItem from 'components/recipes/RecipeListItem'
import Paper from '@material-ui/core/Paper'

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
    const { recipesLoaded, selectedRecipes } = this.props

    if (!recipesLoaded) {
      return null
    }
    return (
      <div>
        <Paper>
          {selectedRecipes.map(r => (
            <RecipeListItem key={r.id} recipe={r} />
          ))}
        </Paper>
      </div>
    )
  }
}

export default RecipesList
