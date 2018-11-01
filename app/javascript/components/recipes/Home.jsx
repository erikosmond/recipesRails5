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
import HistoryListener from 'components/recipes/HistoryListener'
// import Recipe from 'components/recipes/Recipe'
// import RecipeList from 'components/recipes/RecipeList'
// import Hi from 'components/recipes/Hi'
// import Bye from 'components/recipes/Bye'

const Home = () => (
  <Router>
    <HistoryListener>
      <RecipeDropdown />
      <Switch>
        {/* <Route
          path="/hi"
          component={Hi}
        />
        <Route
          path="/bye"
          component={Bye}
        /> */}
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
    </HistoryListener>
  </Router>
)

export default Home
