import React from 'react'
import PropTypes from 'prop-types'
import FormGroup from '@material-ui/core/FormGroup'
import IngredientFilter from 'components/recipes/IngredientFilter'

class IngredientTypeFilter extends React.Component {
  constructor(props) {
    super(props)
    this.typeIsVisible = this.typeIsVisible.bind(this)
  }

  state = {
    visible: false,
  };

  hasVisibleChildren = () => {
    const { childTags, visibleTags } = this.props
    let vis = false
    // update these to for loops, more efficient, won't require vis = vis ||
    vis = vis || Object.keys(childTags).forEach((ct) => {
      if (visibleTags.indexOf(ct) > -1) {
        vis = vis || true
      }
      return vis
    })
    return vis
  }

  typeIsVisible = (bool) => {
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
        familyIsVisible,
      } = this.props
      // show id and label
      return (
        <div>
          {childTags.map(t => (
            <IngredientFilter
              key={t[0]}
              id={t[0]}
              label={t[1]}
              allTags={allTags}
              visibleTags={visibleTags}
              handleFilter={handleFilter}
              familyIsVisible={familyIsVisible}
              typeIsVisible={this.typeIsVisible}
            />
        ))}
        </div>
      )
    }
    return null
  }
}

IngredientTypeFilter.propTypes = {
  id: PropTypes.number.isRequired,
  label: PropTypes.string.isRequired,
  childTags: PropTypes.shape({}),
  handleFilter: PropTypes.func.isRequired,
  familyIsVisible: PropTypes.func.isRequired,
  visibleTags: PropTypes.arrayOf.isRequired,
  allTags: PropTypes.shape({ id: PropTypes.number.isRequired }).isRequired,
}

IngredientTypeFilter.defaultProps = {
  childTags: [],
}
