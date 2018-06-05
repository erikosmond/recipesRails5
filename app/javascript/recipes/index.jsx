/* global document */

import React from 'react'
import ReactDOM from 'react-dom'
import { AppContainer } from 'react-hot-loader'

import Home from '../components/recipes/Home'

require('react-hot-loader/patch')
require('babel-polyfill')

const recipes = document.querySelector('#recipes')

const render = () => {
  ReactDOM.render(
    <AppContainer>
      <Home />
    </AppContainer>,
    recipes,
  )
}

render(Home)

if (module.hot) {
  console.log("it's hot")
  module.hot.accept('../components/recipes/Home', () => { render(Home) })
}
