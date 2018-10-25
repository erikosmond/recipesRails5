import React from 'react'
import PropTypes from 'prop-types'
import RecipeListItem from 'components/recipes/RecipeListItem'
import Paper from '@material-ui/core/Paper'

class RecipeList extends React.Component {
  static propTypes = {
    loadRecipes: PropTypes.func.isRequired,
    selectedRecipes: PropTypes.arrayOf(PropTypes.shape({})),
    recipesLoaded: PropTypes.bool,
    noRecipes: PropTypes.bool.isRequired,
    startingTagId: PropTypes.string.isRequired,
    selectedTag: PropTypes.shape({}).isRequired,
    location: PropTypes.shape({
      search: PropTypes.func,
    }).isRequired,
    match: PropTypes.shape({
      params: PropTypes.shape({
        tagId: PropTypes.string,
      }),
    }).isRequired,
  }

  static defaultProps = {
    recipesLoaded: false,
    selectedRecipes: [],
  }

  constructor(props) {
    super(props)
    this.noRecipes = false
  }

  componentDidMount() {
    const {
      loadRecipes,
      startingTagId,
      match,
    } = this.props
    const { tagId } = match.params
    if (tagId) {
      loadRecipes(tagId)
    } else if (startingTagId) {
      loadRecipes(startingTagId)
    } else {
      this.noRecipes = true
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.location !== this.props.location) {
      const { tagId } = nextProps.match.params
      if (tagId) {
        nextProps.loadRecipes(tagId)
      }
    }
  }

  render() {
    const {
      recipesLoaded,
      selectedRecipes,
      selectedTag,
      noRecipes,
    } = this.props

    if (this.noRecipes || noRecipes) {
      return (<div> {"We don't have any recipes like that."} </div>)
    } else if (!recipesLoaded) {
      return null
    }
    return (
      <div>
        <h2>{selectedTag.name}</h2>
        {selectedTag.description && selectedTag.description.length > 0 &&
          <div>
            {selectedTag.description}
            <br /><br />
          </div>
        }
        {`${selectedRecipes.length} recipes`}

        <Paper>
          {selectedRecipes.map(r => (
            <RecipeListItem key={r.id} recipe={r} />
          ))}
        </Paper>
      </div>
    )
  }
}

export default RecipeList
