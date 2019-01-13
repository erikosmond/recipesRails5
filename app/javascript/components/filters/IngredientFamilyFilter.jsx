import React from 'react'
import PropTypes from 'prop-types'
import FormGroup from '@material-ui/core/FormGroup'
import IngredientTypeFilter from 'components/filters/IngredientTypeFilter'

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
    if (typeof (childTags) === 'object') {
      const keys = Object.keys(childTags)
      for (let ct = 0; ct < keys.length; ct += 1) {
        const key = keys[ct]
        const values = childTags[key]
        if (visibleTags[key]) {
          return true
        } else if (values && values.length > 0) {
          for (let ctv = 0; ctv < values.length; ctv += 1) {
            if (visibleTags[values[ctv]]) {
              return true
            }
          }
        }
      }
    }
    return false
  }

  familyIsVisible = (bool) => {
    // probably don't need this
    this.setState({ visible: bool })
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
      return (
        <div>
          <div>
            {`Ingredient Family ${allTags[id]}`}
          </div>
          <div>
            {childTags && Object.keys(childTags).map(t => (
              <IngredientTypeFilter
                key={`${id}--${t}`}
                id={t}
                label={allTags[parseInt(t, 10)]}
                childTags={childTags[parseInt(t, 10)]}
                allTags={allTags}
                visibleTags={visibleTags}
                handleFilter={handleFilter}
                familyIsVisible={this.familyIsVisible}
              />
          ))}
          </div>
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
