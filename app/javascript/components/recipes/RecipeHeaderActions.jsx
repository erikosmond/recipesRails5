import React from 'react'
import PropTypes from 'prop-types'
import { withStyles } from '@material-ui/core/styles'
import RecipeHeaderAction from 'components/recipes/RecipeHeaderAction'
import { priorityOptions } from 'services/priorityService'
import { ratingOptions } from 'services/ratingService'

const styles = () => ({
  actions: {
    display: 'inline-flex',
  },
})

const starIcon = "M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"

const playlistAddIcon = "M14 10H2v2h12v-2zm0-4H2v2h12V6zM2 16h8v-2H2v2zm19.5-4.5L23 13l-6.99 7-4.51-4.5L13 14l3.01 3 5.49-5.5z"

const RecipeHeaderActions = (props) => {
  const { classes } = props
  return (
    <div className={classes.actions}>
      <RecipeHeaderAction
        label="Rating"
        iconSvgPath={starIcon}
        options={ratingOptions()}
      />
      <RecipeHeaderAction
        label="Priority"
        iconSvgPath={playlistAddIcon}
        options={priorityOptions()}
      />
    </div>
  )
}

RecipeHeaderActions.propTypes = {
  classes: PropTypes.shape({
    actions: PropTypes.shape({}).isRequired,
  }).isRequired,
}

export default withStyles(styles)(RecipeHeaderActions)
