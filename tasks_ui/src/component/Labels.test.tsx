import React from 'react'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { act } from '@testing-library/react-hooks'
import userEvent from '@testing-library/user-event'
import { Provider } from 'react-redux'

import { store, history } from '../state/store'
import Labels from './Labels'
import { labelsSlice } from '../state/labelsSlice'
import * as LabelsSlice from '../state/labelsSlice'
import * as ReactRedux from 'react-redux'

const setMockState = (params) => {
  const { labels } = params

  const mockState = {
    labels: { labels },
  }

  jest
    .spyOn(ReactRedux, 'useSelector')
    .mockImplementation((selector) => selector(mockState))
}

const dispatch = jest
  .spyOn(ReactRedux, 'useDispatch')
  .mockImplementation(() => jest.fn())

const renderIt = () => {
  render(
    <Provider store={store}>
      <Labels />
    </Provider>
  )
}

describe('labels', () => {
  const labels = ['label1', 'label2']
  const indexThunk = jest.spyOn(LabelsSlice, 'index')

  describe('render', () => {
    beforeEach(() => {
      setMockState({ labels })
      renderIt()
    })

    afterEach(() => jest.clearAllMocks())

    it('should list labels', () => {
      labels.map((l) => screen.getByText(l))
    })

    it('should dispatch index at initial render', () => {
      expect(indexThunk).toHaveBeenCalled()
    })
  })
})
