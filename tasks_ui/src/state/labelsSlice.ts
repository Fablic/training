import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit'

const initialState: State = {
  labels: [],
  selected: '',
  authorized: true,
}

export const index = createAsyncThunk(
  'label/index',
  async (params, thunkApi) => {
    const endpoint = '/api/labels.json'
    const ret = await fetch(endpoint, {
      method: 'GET',
      mode: 'cors',
      headers: { 'Content-Type': 'application/json' },
    })

    if (ret.ok) {
      return ret.json()
    } else {
      switch (ret.status) {
        case 401:
          return thunkApi.rejectWithValue({ type: 'unauthorized' })

        default:
          return thunkApi.rejectWithValue(await ret.json())
      }
    }
  }
)

export const labelsSlice = createSlice({
  name: 'labels',
  initialState,
  reducers: {
    select(state, action) {
      state.selected = action.payload
    },

    setAuthorized(s, a) {
      s.authorized = a.payload
    },
  },

  extraReducers: (builder) => {
    builder.addCase(index.fulfilled, (state, action) => {
      state.labels = action.payload
    })

    builder.addCase(index.rejected, (s, a) => {
      if (a.payload) {
        if (a.payload.type) {
          switch (a.payload.type) {
            case 'unauthorized':
              s.authorized = false
              break
          }
        } else {
          s.notice = Object.entries(a.payload)
            .map((e) => e[1].join('\n'))
            .join('\n')
        }
      }
    })
  },
})
