import React from 'react'
import PropTypes from 'prop-types'

class IngredientListItem extends React.Component {
  constructor(props) {
    super(props)
    this.handleClick = this.handleClick.bind(this)
  }

  handleClick(e) {
    e.preventDefault()
    const { ingredient, navigateTags } = this.props
    navigateTags(ingredient.tagId)
  }

  render() {
    const {
      value,
      modificationName,
      tagName,
      tagId,
    } = this.props.ingredient
    const presentModificationName = (modificationName === null) ? '' : modificationName
    const ingredientDetails = (modificationName === 'Juice of') ?
      `${value} ${tagName} Juice` :
      `${value} ${presentModificationName} ${tagName}`
    return (
      <li>
        <a href={`/tags/${tagId}/recipes`} onClick={this.handleClick}> {ingredientDetails} </a>
      </li>
    )
  }
}

IngredientListItem.propTypes = {
  ingredient: PropTypes.shape({
    value: PropTypes.string,
    modificationName: PropTypes.string,
    tagName: PropTypes.string.isRequired,
    tagId: PropTypes.number.isRequired,
  }).isRequired,
  navigateTags: PropTypes.func.isRequired,
}

export default IngredientListItem
