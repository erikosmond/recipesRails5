import React from 'react'
import PropTypes from 'prop-types'
import { withStyles } from '@material-ui/core/styles'
import Chip from '@material-ui/core/Chip'
import Paper from '@material-ui/core/Paper'
import TagFacesIcon from '@material-ui/icons/TagFaces'

const styles = theme => ({
  root: {
    display: 'flex',
    justifyContent: 'center',
    flexWrap: 'wrap',
    padding: theme.spacing.unit / 2,
  },
  chip: {
    margin: theme.spacing.unit / 2,
  },
})

class FilterChips extends React.Component {
  state = {
    chipData: [],
  }

  componentWillReceiveProps(nextProps) {
    const { allTags, selectedFilters } = nextProps
    this.setChips(allTags, selectedFilters)
  }

  setChips(allTags, selectedFilters) {
    const chipData = selectedFilters.map(filter => ({
      key: filter, label: allTags[filter],
    }
    ))
    this.setState(state => ({ ...state, chipData }))
  }

  handleDelete = data => () => {
    const { handleFilter } = this.props
    handleFilter(data.key, false)

    this.setState((state) => {
      const chipData = [...state.chipData]
      const chipToDelete = chipData.indexOf(data)
      chipData.splice(chipToDelete, 1)
      return { chipData }
    })
  }

  render() {
    const { classes } = this.props

    return (
      <Paper className={classes.root}>
        {this.state.chipData.map((data) => {
          let icon = null

          if (data.label === 'React') {
            icon = <TagFacesIcon />
          }

          return (
            <Chip
              key={data.key}
              icon={icon}
              label={data.label}
              onDelete={this.handleDelete(data)}
              className={classes.chip}
            />
          )
        })}
      </Paper>
    )
  }
}

FilterChips.propTypes = {
  classes: PropTypes.shape.isRequired,
  handleFilter: PropTypes.func.isRequired,
  allTags: PropTypes.shape.isRequired,
  selectedFilters: PropTypes.arrayOf.isRequired,
}

export default withStyles(styles)(FilterChips)
