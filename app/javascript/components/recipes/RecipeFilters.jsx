import React from 'react'
import PropTypes from 'prop-types'
import FormGroup from '@material-ui/core/FormGroup'
import PaperContent from '../styled/PaperContent'
import RecipeFilterItem from './RecipeFilterItem'

const RecipeFilters = ({ tags, handleFilter }) => (
  <PaperContent>
    Filters
    <FormGroup>
      {tags.map(t => (
        <RecipeFilterItem
          key={t[0]}
          id={t[0]}
          label={t[1]}
          handleFilter={handleFilter}
        />
      ))}
    </FormGroup>
  </PaperContent>
)
export default RecipeFilters

RecipeFilters.propTypes = {
  handleFilter: PropTypes.func.isRequired,
  tags: PropTypes.arrayOf.isRequired,
}
