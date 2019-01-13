import React from 'react'
import PropTypes from 'prop-types'
import FormControlLabel from '@material-ui/core/FormControlLabel'
import Checkbox from '@material-ui/core/Checkbox'

class IngredientFilter extends React.Component {
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
      <div>
        <div>
          {`Ingredient ${id}`}
        </div>
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
      </div>
    )
  }
}

IngredientFilter.propTypes = {
  id: PropTypes.number.isRequired,
  label: PropTypes.string.isRequired,
  handleFilter: PropTypes.func.isRequired,
}

export default IngredientFilter
