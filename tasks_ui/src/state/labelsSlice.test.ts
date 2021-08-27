import { labelsSlice, index } from './labelsSlice'
const fetchMock = require('fetch-mock-jest')

const reducer = labelsSlice.reducer
const actions = labelsSlice.actions

const initialState = {
  labels: [],
  selected: '',
  authorized: true,
}

describe('labels slice', () => {
  it('should return the initial state', () => {
    expect(reducer(undefined, {})).toEqual(initialState)
  })

  describe('actions', () => {
    it('should update selected', () => {
      const expected = 'hogehoge'
      const actual = reducer(initialState, actions.select(expected))

      expect(actual.selected).toEqual(expected)
    })

    it('should set authorized', () => {
      const actual = reducer({ authorized: false }, actions.setAuthorized(true))

      expect(actual.authorized).toEqual(true)
    })
  })
})

describe('thunks', () => {
  afterEach(() => fetchMock.restore())

  describe('index', () => {
    const endpoint = '/api/labels.json'
    const payload = ['label1', 'label2']

    it('should GET /labels.json', async () => {
      const action = index()
      fetchMock.get(endpoint, {
        status: 200,
        body: JSON.stringify(payload),
      })

      const subject = await action(jest.fn(), jest.fn(), undefined)

      expect(fetchMock).toHaveFetched(endpoint)
      expect(subject.payload).toEqual(payload)
    })

    it('should update the list', () => {
      const actual = reducer(initialState, index.fulfilled(payload))
      expect(actual.labels).toEqual(payload)
    })

    it('should set authorized=true when 200', () => {
      const actual = reducer(initialState, index.fulfilled(payload))
      expect(actual.authorized).toBe(true)
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
})
