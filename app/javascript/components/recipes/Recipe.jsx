import React from 'react'
import PropTypes from 'prop-types'
// import Paper from '@material-ui/core/Paper'

class Recipe extends React.Component {
  static propTypes = {
    loadRecipe: PropTypes.func.isRequired,
    recipe: PropTypes.shape({
      id: PropTypes.number,
      name: PropTypes.string.isRequired,
      ingredients: PropTypes.string.isRequired,
    }),
    history: PropTypes.shape({
      pop: PropTypes.func,
    }).isRequired,
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

  constructor(props) {
    super(props)
    this.goBack = this.goBack.bind(this)
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

  goBack() {
    const { history } = this.props
    history.goBack()
  }

  render() {
    const { recipe, noRecipe } = this.props
    if (!recipe && !recipe.name) {
      return null
    }
    if (noRecipe) {
      return (
        <div>
          <button onClick={this.goBack}> Go Back </button>
          <div> {"We don't have a recipe like that"} </div>
        </div>
      )
    }
    return (
      <div>
        <button onClick={this.goBack}> Go Back </button>
        {recipe.name}
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
