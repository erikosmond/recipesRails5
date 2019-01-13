import React from 'react'
import PropTypes from 'prop-types'
import FormGroup from '@material-ui/core/FormGroup'
import IngredientFilter from 'components/filters/IngredientFilter'

class IngredientTypeFilter extends React.Component {
  state = {
    visible: false, // should be false
  };

  hasVisibleChildren = () => {
    const { childTags, visibleTags, id } = this.props
    if (visibleTags[id]) {
      return true
    }
    for (let ct = 0, n = childTags.length; ct < n; ct += 1) {
      if (visibleTags[childTags[ct]]) {
        return true
      }
    }
    return false
  }

  render() {
    if (this.state.visible || this.hasVisibleChildren()) {
      const {
        visibleTags,
        allTags,
        childTags,
        handleFilter,
        id,
      } = this.props
      // show id and label
      return (
        <div>
          <div>
            {`Ingredient Type ${allTags[id]}`}
          </div>
          <div>
            {childTags.map(t => (
              visibleTags[parseInt(t, 10)] &&
                <IngredientFilter
                  key={`${id}--${t}`}
                  id={t}
                  label={allTags[parseInt(t, 10)]}
                  visibleTags={visibleTags}
                  handleFilter={handleFilter}
                />
          ))}
          </div>
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
  visibleTags: PropTypes.arrayOf.isRequired,
  allTags: PropTypes.shape({ id: PropTypes.number.isRequired }).isRequired,
}

IngredientTypeFilter.defaultProps = {
  childTags: [],
}

export default IngredientTypeFilter
