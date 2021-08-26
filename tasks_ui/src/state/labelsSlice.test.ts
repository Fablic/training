import { labelsSlice, index } from './labelsSlice'
const fetchMock = require('fetch-mock-jest')

const reducer = labelsSlice.reducer
const actions = labelsSlice.actions

const initialState = {
  labels: [],
  selected: '',
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
  })
})

describe('thunks', () => {
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
  })
})
