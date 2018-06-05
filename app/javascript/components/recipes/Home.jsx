import React from 'react'
import PropTypes from 'prop-types'

class Home extends React.Component {
  static propTypes = {
    loadQuotes: PropTypes.func.isRequired,
  }

  static defaultProps = {
    quotesLoaded: false,
  }

  render() {
    return (
      <div>
        Welcomes
      </div>
    )
  }
}

export default Home
