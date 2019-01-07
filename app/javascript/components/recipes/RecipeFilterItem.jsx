import React from 'react'
import PropTypes from 'prop-types'
import FormControlLabel from '@material-ui/core/FormControlLabel'
import Checkbox from '@material-ui/core/Checkbox'

class RecipeFilterItem extends React.Component {
  // This whole class and file has been deprecated for IntredientFilter. This should be removed
  constructor(props) {
    super(props)
    this.handleChange = this.handleChange.bind(this)
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
    const {
      id,
      label,
    } = this.props
    return (
      <FormControlLabel
        control={
          <Checkbox
            checked={this.state.checked}
            onChange={this.handleChange(id)}
            value={id}
          />
        }
        label={label}
      />
    )
  }
}

RecipeFilterItem.propTypes = {
  id: PropTypes.number.isRequired,
  label: PropTypes.string.isRequired,
  handleFilter: PropTypes.func.isRequired,
}

export default RecipeFilterItem
