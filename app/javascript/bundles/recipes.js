import { put, call } from 'redux-saga/effects'
import { takeLatest } from 'redux-saga'
import { callApi } from 'services/rest'

// Actions
const LOAD_RECIPES = 'recipes/loadRecipes'
const LOAD_RECIPES_SUCCESS = 'recipes/loadRecipesSuccess'
const INITIAL_LOAD_OCCURRED = 'recipes/initialLoadOccurred'

// Reducer
const initialState = {
  selectedRecipes: [],
  selectedTagName: '',
  recipesLoaded: false,
  initialLoad: true,
}

export default function recipesReducer(state = initialState, action = {}) {
  switch (action.type) {
    case LOAD_RECIPES:
      return {
        ...state,
        selectedRecipes: [],
        selectedTagName: '',
      }
    case LOAD_RECIPES_SUCCESS:
      return {
        ...state,
        selectedRecipes: action.payload.recipes.recipes,
        selectedTagName: action.payload.recipes.name,
        recipesLoaded: true,
      }
    case INITIAL_LOAD_OCCURRED:
      return {
        ...state,
        initialLoad: false,
      }
    default:
      return state
  }
}

// Action Creators
export function loadRecipes(tagId) {
  return {
    type: LOAD_RECIPES,
    payload: tagId,
  }
}

export function loadRecipesSuccess({ recipes }) {
  return {
    type: LOAD_RECIPES_SUCCESS,
    payload: {
      recipes,
    },
  }
}

export function initialLoadOccurred() {
  return {
    type: INITIAL_LOAD_OCCURRED,
  }
}

// Saga

export function* loadRecipesTask({ payload }) {
  const url = `/api/tags/${payload}/recipes`
  const result = yield call(callApi, url)
  if (result.success) {
    yield put(loadRecipesSuccess({ recipes: result.data }))
  } else {
    // yield put(loadRecipesFailed())
  }
}

/* recipes */

export function* recipesSaga() {
  yield takeLatest(LOAD_RECIPES, loadRecipesTask)
}
