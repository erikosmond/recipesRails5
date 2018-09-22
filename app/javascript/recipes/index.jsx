/* global document */

import React from 'react'
import ReactDOM from 'react-dom'
import { AppContainer } from 'react-hot-loader'
import { Provider } from 'react-redux'

import rootReducer from 'reducers'
import rootSaga from 'saga'
import configureStore from 'store'

import Home from '../components/recipes/Home'

require('react-hot-loader/patch')
require('babel-polyfill')


const home = document.querySelector('#home')

const myStore = {}

const store = configureStore(rootReducer, rootSaga, myStore)

const render = (Component) => {
  ReactDOM.render(
    <AppContainer>
      <Provider store={store}>
        <Home startingTagId={home.dataset.startingTagId} />
      </Provider>
    </AppContainer>,
    home,
  )
}

render(Home)

if (module.hot) {
  module.hot.accept('../components/recipes/Home', () => { render(Home) })
}
