import React from 'react'
import PropTypes from 'prop-types'
import { withStyles } from '@material-ui/core/styles'
import IngredientTypeFilter from 'components/filters/IngredientTypeFilter'
import FormControlLabel from '@material-ui/core/FormControlLabel'
import Checkbox from '@material-ui/core/Checkbox'
import ExpansionPanel from '@material-ui/core/ExpansionPanel'
import ExpansionPanelSummary from '@material-ui/core/ExpansionPanelSummary'
import ExpansionPanelDetails from '@material-ui/core/ExpansionPanelDetails'
import ExpandMoreIcon from '@material-ui/icons/ExpandMore'

const styles = () => ({
  details: {
    display: 'block',
  },
})

class IngredientFamilyFilter extends React.Component {
  state = {
    checked: false,
  }

  hasVisibleChildren = () => {
    const { childTags, visibleTags } = this.props
    if (typeof (childTags) === 'object') {
      const tagList = Object.keys(childTags)
      return this.hasVisibleLevel(tagList, visibleTags)
    }
    return false
  }

  hasVisibleLevel = (childTags, visibleTags) => {
    if (childTags.length > 0) {
      for (let ct = 0; ct < childTags.length; ct += 1) {
        const key = childTags[ct]
        const values = childTags[key]
        if (visibleTags[key]) {
          return true
        } else if (values && values.length > 0) {
          return this.hasVisibleLevel(values, visibleTags)
        }
      }
    }
    return false
  }

  handleChange = id => (event) => {
    const { handleFilter } = this.props
    this.setState({ checked: event.target.checked })
    handleFilter(id, event.target.checked)
  }

  render() {
    if (this.state.visible || this.hasVisibleChildren()) {
      const {
        visibleTags,
        allTags,
        childTags,
        handleFilter,
        id,
        classes,
      } = this.props
      return (
        <ExpansionPanel>
          <ExpansionPanelSummary expandIcon={<ExpandMoreIcon />}>
            <FormControlLabel
              control={
                <Checkbox
                  checked={this.state.checked}
                  onChange={this.handleChange(id)}
                  value={id}
                />
              }
              label={allTags[id]}
            />
          </ExpansionPanelSummary>
          <ExpansionPanelDetails className={classes.details}>
            {childTags && Object.keys(childTags).map(t => (
              <IngredientTypeFilter
                key={`${id}--${t}`}
                id={t}
                label={allTags[parseInt(t, 10)]}
                childTags={childTags[parseInt(t, 10)]}
                allTags={allTags}
                visibleTags={visibleTags}
                handleFilter={handleFilter}
              />
            ))}
          </ExpansionPanelDetails>
        </ExpansionPanel>
      )
    }
    return null
  }
}

IngredientFamilyFilter.propTypes = {
  id: PropTypes.number.isRequired,
  classes: PropTypes.shape().isRequired,
  childTags: PropTypes.shape({}),
  handleFilter: PropTypes.func.isRequired,
  visibleTags: PropTypes.arrayOf.isRequired,
  allTags: PropTypes.shape({ id: PropTypes.number.isRequired }).isRequired,
}

IngredientFamilyFilter.defaultProps = {
  childTags: [],
}

export default withStyles(styles)(IngredientFamilyFilter)
