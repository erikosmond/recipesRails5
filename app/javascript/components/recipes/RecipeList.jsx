import React from 'react'
import PropTypes from 'prop-types'
import FilterByIngredients from 'components/filters/FilterByIngredients'
import RecipeListItem from 'components/recipes/RecipeListItem'
import RelatedTags from 'components/recipes/RelatedTags'
import Paper from '@material-ui/core/Paper'
import PaperContent from '../styled/PaperContent'


class RecipeList extends React.Component {
  static propTypes = {
    loadRecipes: PropTypes.func.isRequired,
    loadTagInfo: PropTypes.func.isRequired,
    handleFilter: PropTypes.func.isRequired,
    clearFilters: PropTypes.func.isRequired,
    updateRecipeTag: PropTypes.func.isRequired,
    selectedRecipes: PropTypes.arrayOf(PropTypes.shape({})),
    recipesLoaded: PropTypes.bool,
    loading: PropTypes.bool,
    tagGroups: PropTypes.shape({}).isRequired,
    allTags: PropTypes.shape({
      id: PropTypes.number.isRequired,
    }).isRequired,
    allTagTypes: PropTypes.shape({
      id: PropTypes.number.isRequired,
    }).isRequired,
    tagsByType: PropTypes.shape({}).isRequired,
    visibleFilterTags: PropTypes.arrayOf,
    noRecipes: PropTypes.bool.isRequired,
    startingTagId: PropTypes.string.isRequired,
    selectedTag: PropTypes.shape({}).isRequired,
    priorities: PropTypes.shape({}).isRequired,
    ratings: PropTypes.shape({}).isRequired,
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
    loading: true,
    selectedRecipes: [],
    visibleFilterTags: [],
  }

  constructor(props) {
    super(props)
    this.noRecipes = false
  }

  componentDidMount() {
    const {
      loadRecipes,
      loadTagInfo,
      startingTagId,
      match,
    } = this.props
    const { tagId } = match.params
    if (tagId) {
      loadRecipes(tagId)
      loadTagInfo(tagId)
    } else if (startingTagId) {
      loadRecipes(startingTagId)
      loadTagInfo(startingTagId)
    } else {
      this.noRecipes = true
    }
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.location !== this.props.location) {
      nextProps.clearFilters()
      const { tagId } = nextProps.match.params
      if (tagId) {
        nextProps.loadRecipes(tagId)
        nextProps.loadTagInfo(tagId)
      }
    }
  }

  componentWillUnmount() {
    this.props.clearFilters()
  }

  render() {
    const {
      recipesLoaded,
      selectedRecipes,
      selectedTag,
      noRecipes,
      loading,
      visibleFilterTags,
      allTags,
      tagGroups,
      handleFilter,
      allTagTypes,
      tagsByType,
      ratings,
      priorities,
      updateRecipeTag,
    } = this.props
    if (loading) {
      return (<div> {'Loading...'} </div>)
    } else if (this.noRecipes || noRecipes) {
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
        <div> {`${selectedRecipes.length} recipes`} </div>

        <Paper>
          <RelatedTags tags={selectedTag.grandparentTags} />
          <RelatedTags tags={selectedTag.parentTags} />
          <RelatedTags tags={selectedTag.childTags} />
          <RelatedTags tags={selectedTag.grandchildTags} />
          <RelatedTags tags={selectedTag.modificationTags} />
          <RelatedTags tags={selectedTag.modifiedTags} />
        </Paper>

        <FilterByIngredients
          visibleTags={visibleFilterTags}
          allTags={allTags}
          tagGroups={tagGroups}
          handleFilter={handleFilter}
          allTagTypes={allTagTypes}
          tagsByType={tagsByType}
        />


        <PaperContent>
          {selectedRecipes.map(r => (
            <RecipeListItem
              key={r.id}
              recipe={r}
              ratings={ratings}
              priorities={priorities}
              updateRecipeTag={updateRecipeTag}
            />
          ))}
        </PaperContent>
      </div>
    )
  }
}

export default RecipeList
