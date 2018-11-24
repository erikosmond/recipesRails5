/* eslint-disable react/jsx-no-bind */

import React from 'react'

import {
  BrowserRouter as Router,
  Route,
  Switch,
} from 'react-router-dom'

import styled from 'styled-components'

import Recipe from 'containers/RecipeContainer'
import RecipeList from 'containers/RecipeListContainer'
import RecipeHeader from 'containers/RecipeHeaderContainer'

const StyledContent = styled.div`
  margin-top: 70px;
`

const Home = () => (
  <Router>
    <div>
      <RecipeHeader />
      <StyledContent>
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
      </StyledContent>
    </div>
  </Router>
)

export default Home
