import React from 'react'
import PropTypes from 'prop-types'
import { withStyles } from '@material-ui/core/styles'
import FormControlLabel from '@material-ui/core/FormControlLabel'
import Checkbox from '@material-ui/core/Checkbox'
import ExpansionPanel from '@material-ui/core/ExpansionPanel'
import ExpansionPanelSummary from '@material-ui/core/ExpansionPanelSummary'
import ExpansionPanelDetails from '@material-ui/core/ExpansionPanelDetails'
import ExpandMoreIcon from '@material-ui/icons/ExpandMore'
import IngredientFilter from 'components/filters/IngredientFilter'

const styles = () => ({
  details: {
    display: 'block',
  },
})

class IngredientTypeFilter extends React.Component {
  // state = {
  //   visible: false, // should be false
  // };

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

  state = {
    checked: false,
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
      // show id and label
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
          </ExpansionPanelDetails>
        </ExpansionPanel>
      )
    }
    return null
  }
}

IngredientTypeFilter.propTypes = {
  id: PropTypes.number.isRequired,
  classes: PropTypes.shape().isRequired,
  childTags: PropTypes.shape({}),
  handleFilter: PropTypes.func.isRequired,
  visibleTags: PropTypes.arrayOf.isRequired,
  allTags: PropTypes.shape({ id: PropTypes.number.isRequired }).isRequired,
}

IngredientTypeFilter.defaultProps = {
  childTags: [],
}

export default withStyles(styles)(IngredientTypeFilter)
