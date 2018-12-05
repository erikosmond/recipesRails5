import React from 'react'
import PropTypes from 'prop-types'
import { withStyles } from '@material-ui/core/styles'
import classnames from 'classnames'
import Card from '@material-ui/core/Card'
import CardHeader from '@material-ui/core/CardHeader'
import { Link } from 'react-router-dom'
import CardContent from '@material-ui/core/CardContent'
import Collapse from '@material-ui/core/Collapse'
import CardActions from '@material-ui/core/CardActions'
import IconButton from '@material-ui/core/IconButton'
import ExpandMoreIcon from '@material-ui/icons/ExpandMore'
import RecipeIngredients from 'components/recipes/RecipeIngredients'
import RecipeInstructions from 'components/recipes/RecipeInstructions'
import RecipeDescription from 'components/recipes/RecipeDescription'
import { allIngredients } from 'services/recipes'

const styles = () => ({
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
    const ingredientNames = Object.values(allIngredients(recipe)).map(ingredient => (
      ingredient.tagName
    ))

    return (
      <Card className={classes.card}>
        <CardHeader
          title={<Link to={`/recipes/${recipe.id}`}>{recipe.name}</Link>}
          subheader={ingredientNames.join(', ')}
        />
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
            <RecipeIngredients recipe={recipe} />
            <RecipeInstructions recipe={recipe} />
            <RecipeDescription recipe={recipe} />
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
