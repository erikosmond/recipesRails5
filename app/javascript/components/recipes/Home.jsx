/* eslint-disable react/jsx-no-bind */

import React from 'react'

import {
  BrowserRouter as Router,
  Route,
  Switch,
} from 'react-router-dom'

import Recipe from 'containers/RecipeContainer'
import RecipeList from 'containers/RecipeListContainer'
import RecipeDropdown from 'containers/RecipeDropdownContainer'

const Home = () => (
  <Router>
    <div>
      <RecipeDropdown />
      <Switch>
        <Route
          path="/tags/:tagId/recipes"
          component={RecipeList}
        />
        <Route
          path="/recipes/:recipeId"
          component={Recipe}
        />
        <Route
          path="/"
          component={RecipeList}
        />
      </Switch>
    </div>
  </Router>
)

export default Home
