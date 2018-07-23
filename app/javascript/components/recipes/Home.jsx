import React from 'react'
import PropTypes from 'prop-types'

class Home extends React.Component {
  static propTypes = {
    recipesLoaded: PropTypes.bool,
  }

  static defaultProps = {
    recipesLoaded: false,
  }

  render() {
    return (
      <div>
        Welcome
      </div>
    )
  }
}

export default Home
