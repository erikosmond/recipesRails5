import React from 'react'
import PropTypes from 'prop-types'
import FormGroup from '@material-ui/core/FormGroup'
import RecipeTypeFilter from 'components/recipes/RecipeFilterItem'

class IngredientFamilyFilter extends React.Component {
  constructor(props) {
    super(props)
    this.familyIsVisible = this.familyIsVisible.bind(this)
  }

  state = {
    visible: false,
  };

  hasVisibleChildren = () => {
    const { childTags, visibleTags } = this.props
    return this.hasVisibleLevel(childTags, visibleTags)
  }

  hasVisibleLevel = (childTags, visibleTags) => {
    if (!childTags && childTags.length < 1) {
      let vis = false
      // update these to for loops, more efficient, won't require vis = vis ||
      vis = vis || Object.keys(childTags).forEach((ct) => {
        if (visibleTags.indexOf(ct) > -1) {
          vis = vis || true
        } else if (childTags && childTags.length > 0) {
          vis = vis || this.hasVisibleBottomLevel(childTags[ct], visibleTags)
        }
        return vis
      })
      return vis
    }
  }

  familyIsVisible = (bool) => {
    // probably don't need this
    this.setState({ visible: bool })
  }

  render() {
    if (this.state.visible || this.hasVisibleChildren) {
      const {
        visibleTags,
        allTags,
        childTags,
        handleFilter,
      } = this.props
      // show id and label
      return (
        <div>
          {childTags && Object.keys(childTags).map(t => (
            <RecipeTypeFilter
              key={t}
              id={t}
              label={childTags[t]}
              allTags={allTags}
              visibleTags={visibleTags}
              handleFilter={handleFilter}
              familyIsVisible={this.familyIsVisible}
            />
        ))}
        </div>
      )
    }
    return null
  }
}

IngredientFamilyFilter.propTypes = {
  id: PropTypes.number.isRequired,
  label: PropTypes.string.isRequired,
  childTags: PropTypes.shape({}),
  handleFilter: PropTypes.func.isRequired,
  visibleTags: PropTypes.arrayOf.isRequired,
  allTags: PropTypes.shape({ id: PropTypes.number.isRequired }).isRequired,
}

IngredientFamilyFilter.defaultProps = {
  childTags: [],
}

export default IngredientFamilyFilter
