import React from 'react'
import PropTypes from 'prop-types'
import FormGroup from '@material-ui/core/FormGroup'
import PaperContent from 'components/styled/PaperContent'
import IngredientFamilyFilter from 'components/filters/IngredientFamilyFilter'
import IngredientTypeFilter from 'components/filters/IngredientTypeFilter'

const FilterByIngredients = ({
  visibleTags,
  handleFilter,
  allTags,
  tagGroups,
  tagsByType,
  allTagTypes,
}) => (
  <PaperContent>
    <FormGroup>
      {tagGroups && Object.keys(tagGroups).map(t => (
        <IngredientFamilyFilter
          key={t}
          id={t}
          label={allTags[t]}
          handleFilter={handleFilter}
          visibleTags={visibleTags}
          allTags={allTags}
          childTags={tagGroups[t]}
        />
      ))}
      {tagsByType && Object.keys(tagsByType).map(t => (
        <IngredientTypeFilter
          key={t}
          id={t}
          label={allTagTypes[t]}
          handleFilter={handleFilter}
          visibleTags={visibleTags}
          allTags={allTags}
          childTags={tagsByType[t]}
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
  allTagTypes: PropTypes.shape({}).isRequired,
  tagGroups: PropTypes.shape({}).isRequired,
  tagsByType: PropTypes.shape({}).isRequired,
}
