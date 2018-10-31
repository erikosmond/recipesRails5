import { put, call } from 'redux-saga/effects'
import { takeLatest } from 'redux-saga'
import { callApi } from 'services/rest'

// Actions
const LOAD_RECIPES = 'recipes/loadRecipes'
const LOAD_RECIPES_SUCCESS = 'recipes/loadRecipesSuccess'
const NO_RECIPES_FOUND = 'recipes/noRecipesFound'
const LOAD_RECIPE = 'recipes/loadRecipe'
const LOAD_RECIPE_SUCCESS = 'recipes/loadRecipeSuccess'
const LOAD_RECIPE_OPTIONS = 'recipes/loadRecipeOptions'
const LOAD_RECIPE_OPTIONS_SUCCESS = 'recipes/loadRecipeOptionsSuccess'
const NO_RECIPE_FOUND = 'recipes/noRecipeFound'
const NO_RECIPE_OPTIONS_FOUND = 'recipes/noRecipeOptionsFound'

// Reducer
const initialState = {
  selectedRecipes: [],
  selectedTag: {},
  recipeOptions: [],
  recipesLoaded: false,
  noRecipes: false,
  noRecipeOptions: false,
}

export default function recipesReducer(state = initialState, action = {}) {
  switch (action.type) {
    case LOAD_RECIPES:
      return {
        ...state,
        selectedRecipes: [],
        selectedTag: '',
      }
    case LOAD_RECIPES_SUCCESS:
      return {
        ...state,
        selectedRecipes: action.payload.recipes.recipes,
        selectedTag: action.payload.recipes.tag,
        recipesLoaded: true,
      }
    case NO_RECIPES_FOUND:
      return {
        ...state,
        noRecipes: true,
      }
    case LOAD_RECIPE:
      return {
        ...state,
        selectedRecipe: {},
      }
    case LOAD_RECIPE_SUCCESS:
      return {
        ...state,
        recipe: action.payload.recipe,
      }
    case LOAD_RECIPE_OPTIONS_SUCCESS:
      return {
        ...state,
        recipeOptions: action.payload.recipeOptions.recipes,
      }
    case NO_RECIPE_FOUND:
      return {
        ...state,
        noRecipe: true,
      }
    case NO_RECIPE_OPTIONS_FOUND:
      return {
        ...state,
        noRecipeOptions: true,
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

export function noRecipesFound() {
  return {
    type: NO_RECIPES_FOUND,
  }
}

export function loadRecipe(recipeId) {
  return {
    type: LOAD_RECIPE,
    payload: recipeId,
  }
}

export function loadRecipeSuccess({ recipe }) {
  return {
    type: LOAD_RECIPE_SUCCESS,
    payload: {
      recipe,
    },
  }
}

export function loadRecipeOptions() {
  return {
    type: LOAD_RECIPE_OPTIONS,
  }
}

export function loadRecipeOptionsSuccess({ recipeOptions }) {
  return {
    type: LOAD_RECIPE_OPTIONS_SUCCESS,
    payload: {
      recipeOptions,
    },
  }
}

export function noRecipeFound() {
  return {
    type: NO_RECIPE_FOUND,
  }
}

export function noRecipeOptionsFound() {
  return {
    type: NO_RECIPE_OPTIONS_FOUND,
  }
}
// Saga

export function* loadRecipesTask({ payload }) {
  const url = `/api/tags/${payload}/recipes`
  const result = yield call(callApi, url)
  if (result.success) {
    yield put(loadRecipesSuccess({ recipes: result.data }))
  } else {
    yield put(noRecipesFound())
  }
}

export function* loadRecipeTask({ payload }) {
  const url = `/api/recipes/${payload}`
  const result = yield call(callApi, url)
  if (result.success) {
    yield put(loadRecipeSuccess({ recipe: result.data }))
  } else {
    yield put(noRecipeFound())
  }
}

export function* loadRecipeOptionsTask() {
  const url = '/api/recipes/'
  const result = yield call(callApi, url)
  if (result.success) {
    yield put(loadRecipeOptionsSuccess({ recipeOptions: result.data }))
  } else {
    yield put(noRecipeOptionsFound())
  }
}
/* recipes */

export function* recipesSaga() {
  yield takeLatest(LOAD_RECIPES, loadRecipesTask)
  yield takeLatest(LOAD_RECIPE, loadRecipeTask)
  yield takeLatest(LOAD_RECIPE_OPTIONS, loadRecipeOptionsTask)
}
