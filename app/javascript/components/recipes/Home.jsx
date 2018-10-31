/* eslint-disable react/jsx-no-bind */

import React from 'react'

import {
  BrowserRouter as Router,
  Route,
  Switch,
} from 'react-router-dom'

import RecipeContainer from 'containers/RecipeContainer'
import RecipeListContainer from 'containers/RecipeListContainer'
import RecipeDropdownContainer from 'containers/RecipeDropdownContainer'

const Home = () => (
  <Router>
    <div>
      <RecipeDropdownContainer />
      <Switch>
        <Route
          path="/tags/:tagId/recipes"
          component={RecipeListContainer}
        />
        <Route
          path="/recipes/:recipeId"
          component={RecipeContainer}
        />
        <Route
          path="/"
          component={RecipeListContainer}
        />
      </Switch>
    </div>
  </Router>
)

export default Home
