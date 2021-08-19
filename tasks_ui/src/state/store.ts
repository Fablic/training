import { combineReducers, configureStore } from '@reduxjs/toolkit'
import { tasksSlice } from './tasksSlice'
import { labelsSlice } from './labelsSlice'

const reducer = combineReducers({
  tasks: tasksSlice.reducer,
  labels: labelsSlice.reducer,
})

export const store = configureStore({
  reducer,
})
