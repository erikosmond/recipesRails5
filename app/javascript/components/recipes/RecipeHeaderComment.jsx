import React from 'react'
import PropTypes from 'prop-types'
import IconButton from '@material-ui/core/IconButton'
import SvgIcon from '@material-ui/core/SvgIcon'

class RecipeHeaderComment extends React.Component {
    // state = {
    //   anchorEl: null,
    // };

    constructor(props) {
      super(props)
      this.handleClick = this.handleClick.bind(this)
    }
  
    handleClick = (event) => {
      const { handleCommentModal, commentRecipeId, commentTagSelectionId, commentBody } = this.props
      handleCommentModal({
        commentRecipeId,
        commentTagSelectionId,
        commentBody,
        commentModalOpen: true,
      })
        // open modal here - inject comment and recipe_id to modal
      // this.setState({ anchorEl: event.currentTarget })
    };

    render() {
        const {
          iconSvgPath,
          label,
        } = this.props
        // const { anchorEl } = this.state
        // const open = Boolean(anchorEl)
    
        return (
          <div>
            <IconButton
              aria-label={label}
              // aria-owns={open ? 'long-menu' : undefined}
              // aria-haspopup="true"
              onClick={this.handleClick}
            >
              <SvgIcon>
                <path d={iconSvgPath} />
              </SvgIcon>
            </IconButton>
          </div>
        )
      }
    }
    
    RecipeHeaderComment.propTypes = {
      label: PropTypes.string.isRequired,
      iconSvgPath: PropTypes.string.isRequired,
      comment: PropTypes.string,
      recipeId: PropTypes.number.isRequired,
      handleCommentModal: PropTypes.func.isRequired,
    }
    
    RecipeHeaderComment.defaultProps = {
      comment: '',
    }
    export default RecipeHeaderComment