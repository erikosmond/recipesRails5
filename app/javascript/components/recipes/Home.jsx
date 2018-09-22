import React from 'react'
import {
  BrowserRouter as Router,
  Route,
} from 'react-router-dom'
import RecipesContainer from 'containers/RecipesContainer'

const Home = props => (
  <Router startingTagId={props.startingTagId}>
    <div>
      <Route
        path="/"
        startingTagId={props.startingTagId}
        render={routeProps => <RecipesContainer {...props} {...routeProps} />}
      />
    </div>
  </Router>
)

export default Home
