import { tasksSlice, index, create, get, update, destroy } from './tasksSlice'
const fetchMock = require('fetch-mock-jest')

const reducer = tasksSlice.reducer
const actions = tasksSlice.actions

const initialState = {
  tasks: [],
  totalPages: 0,
  currentPage: 0,
  pending: false,
  notice: null,
  maintenance: false,
  authorized: false,
}

describe('tasks slice', () => {
  it('should return the initial state', () => {
    expect(reducer(undefined, {})).toEqual(initialState)
  })

  describe('edit actions', () => {
    const task = {
      id: 1,
      name: 'task1',
      description: 'description1',
      edit: false,
    }

    describe('show', () => {
      it('should set edit.name as true', () => {
        const action = actions.show(task.id)
        const actual = reducer({ tasks: [{ ...task, edit: true }] }, action)

        expect(actual.tasks[0].edit).toEqual(false)
      })
    })
    describe('edit', () => {
      it('should set edit.name as false', () => {
        const action = actions.edit(task.id)
        const actual = reducer({ tasks: [task] }, action)

        expect(actual.tasks[0].edit).toEqual(true)
      })
    })
  })

  describe('async thunks', () => {
    afterEach(() => fetchMock.restore())

    describe('index', () => {
      const item1 = {
        id: 1,
        name: 'task1',
      }
      const item2 = {
        id: 2,
        name: 'task2',
      }
      const endpoint = 'http://localhost:3000/tasks.json'
      const payload = {
        tasks: [item1, item2],
        meta: { totalPages: 10, currentPage: 1 },
      }

      it('should GET /tasks.json', async () => {
        const action = index()
        fetchMock.get(endpoint, {
          status: 200,
          body: JSON.stringify(payload),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(endpoint)
        expect(subject.payload).toEqual(payload)
      })

      it('should GET /tasks.json?order=due_date', async () => {
        const target = endpoint + '?order=due_date'
        const action = index({ order: 'due_date' })
        fetchMock.get(target, {
          status: 200,
          body: JSON.stringify(payload),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(target)
      })

      it('should GET /tasks.json?order=due_date_desc', async () => {
        const target = endpoint + '?order=due_date_desc'
        const action = index({ order: 'due_date_desc' })
        fetchMock.get(target, {
          status: 200,
          body: JSON.stringify(payload),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(target)
      })

      it('should GET /tasks.json?q=keyword', async () => {
        const target = endpoint + '?q=keyword'
        const action = index({ query: 'keyword' })
        fetchMock.get(target, {
          status: 200,
          body: JSON.stringify(payload),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(target)
      })

      it('should GET /tasks.json?status=in_progress', async () => {
        const target = endpoint + '?status=in_progress'
        const action = index({ status: 'in_progress' })
        fetchMock.get(target, {
          status: 200,
          body: JSON.stringify(payload),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(target)
      })

      it('should GET /tasks.json?label=label1', async () => {
        const target = endpoint + '?label=label1'
        const action = index({ label: 'label1' })
        fetchMock.get(target, {
          status: 200,
          body: JSON.stringify(payload),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(target)
      })

      it('should GET /tasks.json?page=2', async () => {
        const target = endpoint + '?page=2'
        const action = index({ page: 2 })
        fetchMock.get(target, {
          status: 200,
          body: JSON.stringify(payload),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(target)
      })

      it('should set pending=true when initiated', () => {
        const actual = reducer(initialState, index.pending())
        expect(actual.pending).toBe(true)
      })

      it('should set pending=false when API call has finished', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          index.fulfilled(payload)
        )
        expect(actual.pending).toBe(false)
      })

      it('should set authorized=true when 200', () => {
        const actual = reducer(initialState, index.fulfilled(payload))
        expect(actual.authorized).toBe(true)
      })

      it('should update the list', () => {
        const apiRet = {
          tasks: [item1, item2],
          meta: { totalPages: 10, currentPage: 1 },
        }
        const expected = apiRet.tasks.map((i) => ({
          ...i,
          edit: false,
        }))

        const actual = reducer(
          {
            ...initialState,
            tasks: [
              {
                id: 0,
                name: 'existing task',
                edit: false,
              },
            ],
          },
          index.fulfilled(payload)
        )

        expect(actual.tasks.length).toEqual(expected.length)
        expect(actual.tasks).toEqual(expected)
        expect(actual.totalPages).toEqual(apiRet.meta.totalPages)
        expect(actual.currentPage).toEqual(apiRet.meta.currentPage)
      })

      it('should set pending=false when API call has failed', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          index.rejected()
        )
        expect(actual.pending).toBe(false)
      })

      describe('maintenance mode', () => {
        it('should be rejected with type=maintenance when API returns so', async () => {
          const action = index()
          const payload = { type: 'under_maintenance' }
          fetchMock.get(endpoint, {
            status: 503,
            body: JSON.stringify(payload),
          })
          const subject = await action(jest.fn(), jest.fn(), undefined)
          expect(subject.payload).toEqual(payload)
        })

        it('should set maintenance=true when API call has rejected with 503 w/type=under_maintenance', () => {
          const action = index.rejected()
          action.payload = { type: 'under_maintenance' }
          const actual = reducer(initialState, action)
          expect(actual.maintenance).toBe(true)
        })
      })

      describe('unauthorized', () => {
        it('should be rejected with type=unauthorized when 401', async () => {
          const action = index()
          fetchMock.get(endpoint, {
            status: 401,
            body: '',
          })
          const subject = await action(jest.fn(), jest.fn(), undefined)
          expect(subject.payload).toEqual({ type: 'unauthorized' })
        })

        it('should set authorized=false when 401', () => {
          const action = index.rejected()
          action.payload = { type: 'unauthorized' }
          const actual = reducer(initialState, action)
          expect(actual.authorized).toBe(false)
        })
      })
    })

    describe('create', () => {
      const newItem = {
        id: 1,
        name: 'new task name',
      }
      const endpoint = 'http://localhost:3000/tasks.json'
      const notice = 'created notice'

      it('should POST /tasks.json', async () => {
        const action = create({ name: newItem.name })
        fetchMock.post(endpoint, {
          status: 201,
          body: JSON.stringify({ task: newItem, notice }),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(
          (u, o) =>
            u == endpoint && o.body == JSON.stringify({ name: newItem.name })
        )
      })

      it('should set pending=true when initiated', () => {
        const actual = reducer(initialState, create.pending())
        expect(actual.pending).toBe(true)
      })

      it('should set pending=false when API call has finished', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          create.fulfilled({ task: newItem, notice: 'created notice' })
        )
        expect(actual.pending).toBe(false)
      })

      it('should add the new item at beginning of the list', () => {
        const actual = reducer(
          { ...initialState, tasks: [{ id: 0, name: 'existing task' }] },
          create.fulfilled({ task: newItem, notice })
        )

        expect(actual.tasks.length).toEqual(2)
        expect(actual.tasks[0]).toEqual({
          ...newItem,
          edit: false,
        })
        expect(actual.notice).toEqual(notice)
      })

      it('should set pending=false when API call has failed', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          create.rejected()
        )
        expect(actual.pending).toBe(false)
      })

      it('should be rejected with non-201', async () => {
        const action = create({ name: '' })
        fetchMock.post(endpoint, {
          status: 422,
          body: JSON.stringify({ notice }),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(subject.type).toEqual('task/create/rejected')
        expect(subject.payload).toEqual({ notice })
      })

      it('should set notice when rejected', () => {
        const action = create.rejected()
        action.payload = { name: [notice] }
        const actual = reducer({ ...initialState, pending: true }, action)
        expect(actual.notice).toEqual(notice)
      })

      describe('maintenance mode', () => {
        it('should be rejected with type=maintenance when API returns so', async () => {
          const payload = { type: 'under_maintenance' }
          const action = create({ name: '' })
          fetchMock.post(endpoint, {
            status: 503,
            body: JSON.stringify(payload),
          })
          const subject = await action(jest.fn(), jest.fn(), undefined)
          expect(subject.payload).toEqual(payload)
        })

        it('should set maintenance=true when API call has rejected with 503 w/type=under_maintenance', () => {
          const action = create.rejected()
          action.payload = { type: 'under_maintenance' }
          const actual = reducer(initialState, action)
          expect(actual.maintenance).toBe(true)
        })
      })
    })

    describe('update', () => {
      const item = {
        id: 1,
        name: 'existing task name',
      }
      const updatedItem = { ...item, description: 'new description' }
      const endpoint = `http://localhost:3000/tasks/${item.id}.json`
      const notice = 'updated notice'

      it('should PUT /tasks/1.json with new values as a payload', async () => {
        const action = update(updatedItem)
        const payload = { task: updatedItem, notice }
        fetchMock.put(endpoint, {
          status: 200,
          body: JSON.stringify(payload),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(subject.payload).toEqual(payload)
        expect(fetchMock).toHaveFetched(
          (u, o) =>
            u == endpoint && o.body == JSON.stringify({ task: updatedItem })
        )
      })

      it('should set pending=true when initiated', () => {
        const actual = reducer(initialState, update.pending())
        expect(actual.pending).toBe(true)
      })

      it('should set pending=false when API call has finished', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          update.fulfilled({ task: updatedItem, notice })
        )
        expect(actual.pending).toBe(false)
      })

      it('should add the new item at beginning of the list', () => {
        const actual = reducer(
          { ...initialState, tasks: [item] },
          update.fulfilled({ task: updatedItem, notice })
        )

        expect(actual.tasks[0]).toEqual({
          ...updatedItem,
          edit: false,
        })
        expect(actual.notice).toEqual(notice)
      })

      it('should set pending=false when API call has failed', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          update.rejected()
        )
        expect(actual.pending).toBe(false)
      })

      it('should be rejected with non-201', async () => {
        const action = update({ id: 1, name: '' })
        fetchMock.put('http://localhost:3000/tasks/1.json', {
          status: 422,
          body: JSON.stringify({ notice }),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(subject.type).toEqual('task/update/rejected')
        expect(subject.payload).toEqual({ notice })
      })

      it('should set notice when rejected', () => {
        const action = update.rejected()
        action.payload = { name: [notice] }
        const actual = reducer({ ...initialState, pending: true }, action)
        expect(actual.notice).toEqual(notice)
      })

      describe('maintenance mode', () => {
        it('should be rejected with type=maintenance when API returns so', async () => {
          const action = update(updatedItem)
          const payload = { type: 'under_maintenance' }
          fetchMock.put('http://localhost:3000/tasks/1.json', {
            status: 503,
            body: JSON.stringify(payload),
          })
          const subject = await action(jest.fn(), jest.fn(), undefined)
          expect(subject.payload).toEqual(payload)
        })

        it('should set maintenance=true when API call has rejected with 503 w/type=under_maintenance', () => {
          const action = update.rejected()
          action.payload = { type: 'under_maintenance' }
          const actual = reducer(initialState, action)
          expect(actual.maintenance).toBe(true)
        })
      })
    })

    describe('destroy', () => {
      const item = {
        id: 1,
        name: 'existing task name',
      }
      const endpoint = `http://localhost:3000/tasks/${item.id}.json`
      const notice = 'deleted notice'

      it('should DELETE /tasks/1.json', async () => {
        const action = destroy({ id: item.id })
        fetchMock.delete(endpoint, {
          status: 200,
          body: JSON.stringify({ notice }),
        })

        const subject = await action(jest.fn(), jest.fn(), undefined)

        expect(fetchMock).toHaveFetched(endpoint)
        expect(subject.payload.id).toEqual(item.id)
        expect(subject.payload.notice).toEqual(notice)
      })

      it('should set pending=true when initiated', () => {
        const actual = reducer(initialState, destroy.pending())
        expect(actual.pending).toBe(true)
      })

      it('should set pending=false when API call has finished', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          destroy.fulfilled({ id: item.id, notice })
        )
        expect(actual.pending).toBe(false)
      })

      it('should add the new item at beginning of the list', () => {
        const actual = reducer(
          { ...initialState, tasks: [item, { ...item, ...{ id: 0 } }] },
          destroy.fulfilled({ id: item.id, notice })
        )

        expect(actual.tasks.length).toEqual(1)
        expect(actual.tasks[0]).not.toEqual(item)
        expect(actual.notice).toEqual(notice)
      })

      it('should set pending=false when API call has failed', () => {
        const actual = reducer(
          { ...initialState, pending: true },
          destroy.rejected()
        )
        expect(actual.pending).toBe(false)
      })

      describe('maintenance mode', () => {
        it('should be rejected with type=maintenance when API returns so', async () => {
          const payload = { type: 'under_maintenance' }
          const action = destroy({ id: item.id })
          fetchMock.delete(endpoint, {
            status: 503,
            body: JSON.stringify(payload),
          })
          const subject = await action(jest.fn(), jest.fn(), undefined)
          expect(subject.payload).toEqual(payload)
        })

        it('should set maintenance=true when API call has rejected with 503 w/type=under_maintenance', () => {
          const action = destroy.rejected()
          action.payload = { type: 'under_maintenance' }
          const actual = reducer(initialState, action)
          expect(actual.maintenance).toBe(true)
        })
      })
    })
  })

  describe('utility actions', () => {
    describe('notice', () => {
      const action = actions.setNotice(null)
      const actual = reducer({ notice: 'hogehoge' }, action)

      expect(actual.notice).toEqual(null)
    })
  })
})
