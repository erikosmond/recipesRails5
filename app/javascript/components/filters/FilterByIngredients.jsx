import React from 'react'
import PropTypes from 'prop-types'
import FormGroup from '@material-ui/core/FormGroup'
import PaperContent from 'components/styled/PaperContent'
import IngredientFamilyFilter from 'components/filters/IngredientFamilyFilter'

const FilterByIngredients = ({
  visibleTags,
  handleFilter,
  allTags,
  tagGroups,
}) => (
  <PaperContent>
    Filters
    <FormGroup>
      {tagGroups && Object.keys(tagGroups).map(t => (
        <IngredientFamilyFilter
          key={t[0]}
          id={t}
          label={allTags[t]}
          handleFilter={handleFilter}
          visibleTags={visibleTags}
          allTags={allTags}
          childTags={tagGroups[t]}
        />
      ))}
    </FormGroup>
  </PaperContent>
)
export default FilterByIngredients

FilterByIngredients.propTypes = {
  handleFilter: PropTypes.func.isRequired,
  visibleTags: PropTypes.arrayOf.isRequired,
  allTags: PropTypes.shape({ id: PropTypes.number.isRequired }).isRequired,
  tagGroups: PropTypes.shape({}).isRequired,
}
