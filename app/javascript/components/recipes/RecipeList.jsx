import React from 'react'
import PropTypes from 'prop-types'
import FilterByIngredients from 'components/filters/FilterByIngredients'
import FilterChips from 'components/filters/FilterChips'
import RecipeListItem from 'components/recipes/RecipeListItem'
import RelatedTags from 'components/recipes/RelatedTags'
import PaperContent from '../styled/PaperContent'
import PaperSidebar from '../styled/PaperSidebar'

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
      id: PropTypes.number,
    }).isRequired,
    allTagTypes: PropTypes.shape({
      id: PropTypes.number,
    }).isRequired,
    tagsByType: PropTypes.shape({}).isRequired,
    visibleFilterTags: PropTypes.arrayOf(PropTypes.shape({})),
    selectedFilters: PropTypes.arrayOf(PropTypes.number),
    visibleRecipeCount: PropTypes.number,
    noRecipes: PropTypes.bool,
    startingTagId: PropTypes.string.isRequired,
    selectedTag: PropTypes.shape({}).isRequired,
    priorities: PropTypes.shape({}).isRequired,
    ratings: PropTypes.shape({}).isRequired,
    location: PropTypes.shape({
      search: PropTypes.string,
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
    noRecipes: true,
    selectedFilters: [],
    selectedRecipes: [],
    visibleFilterTags: [],
    visibleRecipeCount: 0,
  }

  constructor(props) {
    super(props)
    this.noRecipes = false
  }

  // TODO: This is getting called dozens of times
  // componentDidMount() {
  //   const {
  //     loadRecipes,
  //     loadTagInfo,
  //     startingTagId,
  //     match,
  //   } = this.props
  //   const { tagId } = match.params
  //   if (tagId) {
  //     loadRecipes(tagId)
  //     loadTagInfo(tagId)
  //   } else if (startingTagId) {
  //     loadRecipes(startingTagId)
  //     loadTagInfo(startingTagId)
  //   } else {
  //     this.noRecipes = true
  //   }
  // }

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

  renderHeaderWithCount() {
    const { selectedRecipes, visibleRecipeCount } = this.props
    const selectedRecipeCount = selectedRecipes.length
    const prefix = selectedRecipeCount === visibleRecipeCount ? '' : `${visibleRecipeCount} of `
    return (
      <h2> Recipes ({prefix + selectedRecipeCount}) </h2>
    )
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
      selectedFilters,
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
        <h1>{selectedTag.name}</h1>
        {selectedTag.description && selectedTag.description.length > 0 &&
          <div>
            {selectedTag.description}
            <br /><br />
          </div>
        }

        <FilterChips
          allTags={allTags}
          selectedFilters={selectedFilters}
          handleFilter={handleFilter}
          selectedTag={selectedTag}
        />

        <FilterByIngredients
          visibleTags={visibleFilterTags}
          allTags={allTags}
          tagGroups={tagGroups}
          selectedFilters={selectedFilters}
          handleFilter={handleFilter}
          allTagTypes={allTagTypes}
          tagsByType={tagsByType}
        />


        <PaperContent>
          {this.renderHeaderWithCount()}
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

        <PaperSidebar>
          <h2> Related </h2>
          <RelatedTags tags={selectedTag.grandparentTags} />
          <RelatedTags tags={selectedTag.parentTags} />
          <RelatedTags tags={selectedTag.childTags} />
          <RelatedTags tags={selectedTag.grandchildTags} />
          <RelatedTags tags={selectedTag.sisterTags} />
          <RelatedTags tags={selectedTag.modificationTags} />
          <RelatedTags tags={selectedTag.modifiedTags} />
        </PaperSidebar>
      </div>
    )
  }
}

export default RecipeList
