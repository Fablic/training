import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit'

const initialState: State = {
  labels: [],
  selected: '',
}

export const index = createAsyncThunk('label/index', async (params, _) => {
  const endpoint = '/api/labels.json'
  const ret = await fetch(endpoint, {
    method: 'GET',
    mode: 'cors',
    headers: { 'Content-Type': 'application/json' },
  })

  if (ret.ok) return ret.json()
})

export const labelsSlice = createSlice({
  name: 'labels',
  initialState,
  reducers: {
    select(state, action) {
      state.selected = action.payload
    },
  },

  extraReducers: (builder) => {
    builder.addCase(index.fulfilled, (state, action) => {
      state.labels = action.payload
    })
  },
})
