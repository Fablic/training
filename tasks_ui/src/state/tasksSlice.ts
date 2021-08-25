import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit'

const initialState: State = {
  tasks: [],
  totalPages: 0,
  currentPage: 0,
  pending: false,
  notice: null,
  maintenance: false,
  authorized: false,
}

export const index = createAsyncThunk(
  'task/index',
  async (params, thunkApi) => {
    let endpoint = 'http://localhost:3000/tasks.json'
    const qs = []
    if (params) {
      if (params.order) {
        qs.push(`order=${params.order}`)
      }

      if (params.query) {
        qs.push(`q=${params.query}`)
      }

      if (params.status) {
        qs.push(`status=${params.status}`)
      }

      if (params.page) {
        qs.push(`page=${params.page}`)
      }

      if (params.label) qs.push(`label=${params.label}`)
    }
    if (qs.length > 0) {
      endpoint += `?${qs.join('&')}`
    }

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

export const create = createAsyncThunk(
  'task/create',
  async (params, thunkApi) => {
    const payload = {
      name: params.name,
    }
    const ret = await fetch('http://localhost:3000/tasks.json', {
      method: 'POST',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    })

    if (ret.ok) {
      return ret.json()
    } else {
      return thunkApi.rejectWithValue(await ret.json())
    }
  }
)

export const update = createAsyncThunk(
  'task/update',
  async (params, thunkApi) => {
    const ret = await fetch(`http://localhost:3000/tasks/${params.id}.json`, {
      method: 'PUT',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ task: params }),
    })

    if (ret.ok) {
      return ret.json()
    } else {
      return thunkApi.rejectWithValue(await ret.json())
    }
  }
)

export const destroy = createAsyncThunk(
  'task/destroy',
  async (params, thunkApi) => {
    const ret = await fetch(`http://localhost:3000/tasks/${params.id}.json`, {
      method: 'DELETE',
      mode: 'cors',
      headers: {
        'Content-Type': 'application/json',
      },
    })

    if (ret.ok) {
      return { ...(await ret.json()), id: params.id }
    } else {
      return thunkApi.rejectWithValue(await ret.json())
    }
  }
)

const findTask = (state, id) => {
  return state.tasks.find((t) => id == t.id)
}

export const tasksSlice = createSlice({
  name: 'tasks',
  initialState,
  reducers: {
    show(state, action) {
      const target = findTask(state, action.payload)
      target.edit = false
    },
    edit(state, action) {
      const target = findTask(state, action.payload)
      target.edit = true
    },
    setNotice(state, action) {
      state.notice = action.payload
    },
  },

  extraReducers: (builder) => {
    ;[index, create, update, destroy].forEach((t) => {
      builder.addCase(t.pending, (s) => {
        s.pending = true
      })
      builder.addCase(t.rejected, (s, a) => {
        s.pending = false

        if (a.payload) {
          if (a.payload.type) {
            switch (a.payload.type) {
              case 'under_maintenance':
                s.maintenance = true
                break

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
    })

    builder.addCase(index.fulfilled, (state, action) => {
      state.pending = false
      state.authorized = true
      state.tasks = action.payload.tasks.map((i) => ({
        ...i,
        edit: false,
      }))
      state.totalPages = action.payload.meta.totalPages
      state.currentPage = action.payload.meta.currentPage
    })

    builder.addCase(create.fulfilled, (state, action) => {
      state.authorized = true
      const { task, notice } = action.payload
      state.pending = false

      state.tasks = [{ ...task, edit: false }, ...state.tasks]
      state.notice = notice
    })

    builder.addCase(update.fulfilled, (state, action) => {
      state.authorized = true
      const { task, notice } = action.payload
      state.pending = false

      const index = state.tasks.findIndex((t) => t.id == task.id)
      state.tasks[index] = {
        ...task,
        edit: false,
      }
      state.notice = notice
    })

    builder.addCase(destroy.fulfilled, (state, action) => {
      state.authorized = true
      const { id, notice } = action.payload
      state.pending = false

      state.tasks = state.tasks.filter((t) => t.id != id)
      state.notice = notice
    })
  },
})
