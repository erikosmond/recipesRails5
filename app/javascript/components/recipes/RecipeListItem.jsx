import React from 'react'
import PropTypes from 'prop-types'
import { withStyles } from '@material-ui/core/styles'
import classnames from 'classnames'
import Card from '@material-ui/core/Card'
import CardHeader from '@material-ui/core/CardHeader'
import CardContent from '@material-ui/core/CardContent'
import Collapse from '@material-ui/core/Collapse'
import Typography from '@material-ui/core/Typography'
import CardActions from '@material-ui/core/CardActions'
import IconButton from '@material-ui/core/IconButton'
import ExpandMoreIcon from '@material-ui/icons/ExpandMore'


const styles = () => ({
// const styles = theme => ({
  card: {
    maxWidth: 400,
  },
})

class RecipeListItem extends React.Component {
  state = { expanded: false };

  handleExpandClick = () => {
    this.setState(state => ({ expanded: !state.expanded }))
  };

  render() {
    const { recipe, classes } = this.props

    return (
      <Card className={classes.card}>
        <CardHeader
          title={recipe.name}
        />
        <CardContent>
          {recipe.instructions}
        </CardContent>
        <CardActions className={classes.actions} disableActionSpacing>
          <IconButton
            className={classnames(classes.expand, {
              [classes.expandOpen]: this.state.expanded,
            })}
            onClick={this.handleExpandClick}
            aria-expanded={this.state.expanded}
            aria-label="Show more"
          >
            <ExpandMoreIcon />
          </IconButton>
        </CardActions>
        <Collapse in={this.state.expanded} timeout="auto" unmountOnExit>
          <CardContent>
            <Typography paragraph variant="body2">
              Instructions:
            </Typography>
            <Typography paragraph>
              {recipe.instructions}
            </Typography>
          </CardContent>
        </Collapse>
      </Card>
    )
  }
}

RecipeListItem.propTypes = {
  recipe: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string.isRequired,
    ingredients: PropTypes.string.isRequired,
  }).isRequired,
  classes: PropTypes.shape({
    card: PropTypes.shape({}).isRequired,
  }).isRequired,
}

export default withStyles(styles)(RecipeListItem)
