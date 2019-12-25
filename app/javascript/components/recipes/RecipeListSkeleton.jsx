import React from 'react'
import PropTypes from 'prop-types'
import RecipeList from 'components/recipes/RecipeList'

class RecipeListSkeleton extends React.Component {
  
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

    recipesReady(props) {
        return props.loading !== undefined && !props.loading &&
        props.tagsByType !== undefined && Object.keys(props.tagsByType).length > 0 &&
        props.priorities !== undefined && Object.keys(props.priorities).length > 0 &&
        props.ratings !== undefined && Object.keys(props.ratings).length > 0 &&
        props.allTags !== undefined && Object.keys(props.allTags).length > 0 &&
        props.allTagTypes !== undefined && Object.keys(props.allTagTypes).length > 0 &&
        props.selectedRecipes !== undefined &&
        props.visibleRecipeCount !== undefined && 
        props.selectedTag !== undefined
    }

    render() {
        if (this.recipesReady(this.props)) {
            return (<RecipeList
                {...this.props}
                />)
        } else {
            return (<div> {'Loading...'} </div>)
        }
    }

}
RecipeListSkeleton.propTypes = {
    loadRecipes: PropTypes.func.isRequired,
    loadTagInfo: PropTypes.func.isRequired,
    handleFilter: PropTypes.func.isRequired,
    clearFilters: PropTypes.func.isRequired,
    resetPagedCount: PropTypes.func.isRequired,
    updateRecipeTag: PropTypes.func.isRequired,
    selectedRecipes: PropTypes.arrayOf(PropTypes.shape({})),
    recipesLoaded: PropTypes.bool,
    loading: PropTypes.bool,
    tagGroups: PropTypes.shape({}).isRequired,
    allTags: PropTypes.shape({
      id: PropTypes.number,
    }),
    allTagTypes: PropTypes.shape({
      id: PropTypes.number,
    }),
    tagsByType: PropTypes.shape({}),
    visibleFilterTags: PropTypes.shape({}),
    selectedFilters: PropTypes.arrayOf(PropTypes.number),
    visibleRecipeCount: PropTypes.number,
    noRecipes: PropTypes.bool,
    startingTagId: PropTypes.string.isRequired,
    showMoreRecipes: PropTypes.func.isRequired,
    selectedTag: PropTypes.shape({}),
    priorities: PropTypes.shape({}),
    ratings: PropTypes.shape({}),
    location: PropTypes.shape({
      search: PropTypes.string,
    }).isRequired,
    match: PropTypes.shape({
      params: PropTypes.shape({
        tagId: PropTypes.string,
      }),
    }).isRequired,
}

export default RecipeListSkeleton