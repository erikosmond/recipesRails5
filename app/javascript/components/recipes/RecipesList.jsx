import React from 'react'
import PropTypes from 'prop-types'
import RecipeListItem from 'components/recipes/RecipeListItem'
import Paper from '@material-ui/core/Paper'

class RecipesList extends React.Component {
  static propTypes = {
    loadRecipes: PropTypes.func.isRequired,
    initialLoadOccurred: PropTypes.func.isRequired,
    selectedRecipes: PropTypes.arrayOf(PropTypes.shape({})),
    recipesLoaded: PropTypes.bool,
    initialLoad: PropTypes.bool.isRequired,
    startingTagId: PropTypes.string.isRequired,
    selectedTag: PropTypes.shape({}).isRequired,
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

  static getTagId(location) {
    const tagPresent = location.pathname.match(/tags\/\d*\//)
    return tagPresent && tagPresent[0].split('/')[1]
  }

  constructor(props) {
    super(props)
    this.noRecipes = false
    this.navigateTags = this.navigateTags.bind(this)
  }

  componentDidMount() {
    const {
      loadRecipes,
      startingTagId,
      location,
      initialLoad,
    } = this.props
    const tagId = RecipesList.getTagId(location)
    if (tagId && initialLoad) {
      loadRecipes(startingTagId)
    } else if (startingTagId) {
      loadRecipes(startingTagId)
    } else {
      this.noRecipes = true
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.location !== this.props.location) {
      const tagId = RecipesList.getTagId(nextProps.location)
      if (tagId && !nextProps.initialLoad) {
        nextProps.loadRecipes(tagId)
      }
    }
  }

  navigateTags(tagId) {
    const { history } = this.props
    history.push(`/tags/${tagId}/recipes`)
  }

  render() {
    const {
      recipesLoaded,
      selectedRecipes,
      selectedTag,
      initialLoadOccurred,
    } = this.props

    if (this.noRecipes) {
      return (<div> The recipes you seek do not exist </div>)
    } else if (!recipesLoaded) {
      return null
    }
    initialLoadOccurred()
    return (
      <div>
        {selectedTag.name}
        <Paper>
          {selectedRecipes.map(r => (
            <RecipeListItem key={r.id} recipe={r} navigateTags={this.navigateTags} />
          ))}
        </Paper>
      </div>
    )
  }
}

export default RecipesList
