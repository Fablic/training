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
  const { labels, selected } = params

  const mockState = {
    labels: { labels, selected },
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
  const select = jest.spyOn(labelsSlice.actions, 'select')

  describe('render', () => {
    beforeEach(() => {
      setMockState({ labels, selected: labels[0] })
      renderIt()
    })

    afterEach(() => jest.clearAllMocks())

    it('should list labels', () => {
      labels.map((l) => screen.getByText(l))
    })

    it('should dispatch index at initial render', () => {
      expect(indexThunk).toHaveBeenCalled()
    })

    describe('update button', () => {
      it('should dispatch index when is clicked', () => {
        const button = screen.getByLabelText('all labels update')
        jest.clearAllMocks()
        userEvent.click(button)

        expect(indexThunk).toHaveBeenCalled()
      })
    })

    describe('select/unselect', () => {
      it('should show the selected label as it is', () => {
        const chips = screen.getAllByLabelText('all labels chip')
        expect(chips[0].className).toMatch(/MuiChip-colorPrimary/)
        expect(chips[1].className).not.toMatch(/MuiChip-colorPrimary/)
      })

      it('should dispatch select when is clicked', () => {
        const target = labels[labels.length - 1]
        const chip = screen.getByText(target)
        userEvent.click(chip)
        expect(select).toHaveBeenCalledWith(target)
      })

      it('should dispatch select with blank when selected is clicked', () => {
        const target = labels[0]
        const chip = screen.getByText(target)
        userEvent.click(chip)
        expect(select).toHaveBeenCalledWith('')
      })
    })
  })
})
