/* eslint-disable react/jsx-no-bind */

import React from 'react'
import PropTypes from 'prop-types'

import {
  BrowserRouter as Router,
  Route,
  Switch,
} from 'react-router-dom'
import RecipesContainer from 'containers/RecipesContainer'

const Home = props => (
  <Router>
    <Switch>
      <Route
        path="/"
        startingTagId={props.startingTagId}
        render={routeProps => <RecipesContainer {...props} {...routeProps} />}
      />
      <Route
        path="/tags/:tagId/recipes"
        render={routeProps => <RecipesContainer {...props} {...routeProps} />}
      />
    </Switch>
  </Router>
)

Home.propTypes = {
  startingTagId: PropTypes.string,
}

Home.defaultProps = {
  startingTagId: undefined,
}

export default Home
