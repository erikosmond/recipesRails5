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
  state = {
    checked: false,
  }

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

  handleChange = id => (event) => {
    const { handleFilter } = this.props
    this.setState({ checked: event.target.checked })
    handleFilter(id, event.target.checked)
  }

  render() {
    if (this.state.visible || this.hasVisibleChildren()) {
      const {
        visibleTags,
        tagNameById,
        childTags,
        handleFilter,
        id,
        classes,
        selectable,
        label,
      } = this.props
      return (
        <ExpansionPanel expanded={this.state.expansionPanelOpen}>
          <ExpansionPanelSummary expandIcon={<ExpandMoreIcon />}>
            {selectable && <FormControlLabel
              control={
                <Checkbox
                  checked={this.state.checked}
                  onChange={this.handleChange(id)}
                  value={id}
                />
              }
              label={tagNameById(id)}
            />}
            { !selectable && label }
          </ExpansionPanelSummary>
          <ExpansionPanelDetails className={classes.details}>
            {childTags.map(t => (
              visibleTags[parseInt(t, 10)] &&
                <IngredientFilter
                  key={`${id}--${t}`}
                  id={t}
                  label={tagNameById(parseInt(t, 10))}
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
  tagNameById: PropTypes.func.isRequired,
  selectable: PropTypes.bool,
  label: PropTypes.string,
}

IngredientTypeFilter.defaultProps = {
  childTags: [],
  selectable: false,
  label: '',
}

export default withStyles(styles)(IngredientTypeFilter)
