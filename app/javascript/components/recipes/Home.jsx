/* eslint-disable react/jsx-no-bind */

import React from 'react'
import PropTypes from 'prop-types'

import {
  BrowserRouter as Router,
  Route,
  Switch,
} from 'react-router-dom'
import RecipeContainer from 'containers/RecipeContainer'
import RecipeListContainer from 'containers/RecipeListContainer'

const Home = props => (
  <Router>
    <Switch>
      <Route
        path="/tags/:tagId/recipes"
        render={routeProps => <RecipeListContainer {...props} {...routeProps} />}
      />
      <Route
        path="/recipes/:recipeId"
        render={routeProps => <RecipeContainer {...props} {...routeProps} />}
      />
      <Route
        path="/"
        startingTagId={props.startingTagId}
        render={routeProps => <RecipeListContainer {...props} {...routeProps} />}
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
