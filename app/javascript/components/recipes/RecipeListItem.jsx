import React from 'react'
import PropTypes from 'prop-types'
import { withStyles } from '@material-ui/core/styles'
import classnames from 'classnames'
import Card from '@material-ui/core/Card'
import CardHeader from '@material-ui/core/CardHeader'
// import { Link } from 'react-router-dom'
import CardContent from '@material-ui/core/CardContent'
import Collapse from '@material-ui/core/Collapse'
import Typography from '@material-ui/core/Typography'
import CardActions from '@material-ui/core/CardActions'
import IconButton from '@material-ui/core/IconButton'
import IngredientListItem from 'components/recipes/IngredientListItem'
import ExpandMoreIcon from '@material-ui/icons/ExpandMore'


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
    const ingredientNames = Object.values(recipe.ingredients).map(ingredient => (
      ingredient.tagName
    ))

    return (
      <Card className={classes.card}>
        {/* <Link to={`/recipes/${recipe.id}`}> <h2> {recipe.name} </h2> </Link> */}
        <CardHeader
          title={<a href={`/recipes/${recipe.id}`}>{recipe.name}</a>}
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
            <Typography paragraph variant="body2">
              Ingredients:
            </Typography>
            <ul>
              {Object.values(recipe.ingredients).map(ingredient => (
                <IngredientListItem key={ingredient.id} ingredient={ingredient} />
              ))}
            </ul>
            <Typography paragraph variant="body2">
              Instructions:
            </Typography>
            <Typography paragraph>
              {recipe.instructions}
            </Typography>
            {recipe.description && recipe.description.length > 0 &&
              <div>
                <Typography paragraph variant="body2">
                  Description:
                </Typography>
                <Typography paragraph>
                  {recipe.description}
                </Typography>
              </div>
            }
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
