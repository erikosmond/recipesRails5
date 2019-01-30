import React from 'react'
import PropTypes from 'prop-types'
import IconButton from '@material-ui/core/IconButton'
import Menu from '@material-ui/core/Menu'
import SvgIcon from '@material-ui/core/SvgIcon'
import MenuItem from '@material-ui/core/MenuItem'

const ITEM_HEIGHT = 48

class RecipeHeaderAction extends React.Component {
  state = {
    anchorEl: null,
  };

  handleClick = (event) => {
    this.setState({ anchorEl: event.currentTarget })
  };

  handleClose = () => {
    this.setState({ anchorEl: null })
  }

  render() {
    const { iconSvgPath, options, label } = this.props
    const { anchorEl } = this.state
    const open = Boolean(anchorEl)

    return (
      <div>
        <IconButton
          aria-label={label}
          aria-owns={open ? 'long-menu' : undefined}
          aria-haspopup="true"
          onClick={this.handleClick}
        >
          <SvgIcon>
            <path d={iconSvgPath} />
          </SvgIcon>
        </IconButton>
        <Menu
          id="long-menu"
          anchorEl={anchorEl}
          open={open}
          onClose={this.handleClose}
          PaperProps={{
            style: {
              maxHeight: ITEM_HEIGHT * 4.5,
              width: 200,
            },
          }}
        >
          {options.map(option => (
            <MenuItem key={option} selected={option === 'Pyxis'} onClick={this.handleClose}>
              {option}
            </MenuItem>
          ))}
        </Menu>
      </div>
    )
  }
}

RecipeHeaderAction.propTypes = {
  label: PropTypes.string.isRequired,
  iconSvgPath: PropTypes.string.isRequired,
  options: PropTypes.arrayOf(PropTypes.string).isRequired,
}

export default RecipeHeaderAction
