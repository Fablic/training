import React from 'react'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { act } from '@testing-library/react-hooks'
import userEvent from '@testing-library/user-event'
import { Provider } from 'react-redux'

import { store, history } from '../state/store'
import Tasks from './Tasks'
import { tasksSlice } from '../state/tasksSlice'
import * as TasksSlice from '../state/tasksSlice'
import * as ReactRedux from 'react-redux'

const setMockState = (params) => {
  const { tasks, totalPages, currentPage, authorized } = params

  const mockState = {
    tasks: {
      tasks,
      pending: false,
      totalPages,
      currentPage,
      authorized,
    },
    labels: [],
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
      <Tasks />
    </Provider>
  )
}

const mockTask = {
  id: 1,
  name: 'task name',
  description: 'task description',
  edit: false,
}

describe('Tasks', () => {
  const tasks = [...Array(3)].map((_, i) => ({
    ...mockTask,
    id: i,
    name: `${mockTask.name} ${i}`,
  }))

  const indexThunk = jest.spyOn(TasksSlice, 'index')

  describe('render', () => {
    beforeEach(() => {
      setMockState({ tasks, authorized: true })
      renderIt()
    })

    afterEach(() => jest.clearAllMocks())

    it('should list task items', () => {
      const names = screen.getAllByLabelText('name-display')
      expect(names.map((n) => n.innerHTML)).toEqual(tasks.map((t) => t.name))
    })

    it('should dispatch index at initial render', () => {
      expect(indexThunk).toHaveBeenCalled()
    })

    describe('sort order', () => {
      beforeEach(() => jest.clearAllMocks())

      it('should sort by due date', () => {
        const chip = screen.getByLabelText('sort-due-date')
        userEvent.click(chip)
        expect(chip.className).toMatch(/MuiChip-clickableColorPrimary/)
      })

      it('should sort by due date desc', () => {
        const chip = screen.getByLabelText('sort-due-date-desc')
        userEvent.click(chip)
        expect(chip.className).toMatch(/MuiChip-clickableColorPrimary/)
      })
    })

    describe('search form', () => {
      it('initially has search input and button', () => {
        screen.getByLabelText('search button')
        screen.getByLabelText('search input')
        expect(screen.queryAllByLabelText('clear searchword').length).toEqual(0)
      })

      describe('clear button', () => {
        let input

        beforeEach(() => {
          input = screen.getByLabelText('search input')
          userEvent.type(input, 'searchword')
        })

        it('should be present', () => {
          screen.getByLabelText('clear searchword')
        })

        it('should clear searchword', () => {
          const btn = screen.getByLabelText('clear searchword')
          userEvent.click(btn)

          expect(input.querySelector('input').value).toEqual('')
          expect(screen.queryAllByLabelText('clear searchword').length).toEqual(
            0
          )
        })
      })
    })
  })

  describe('paginator', () => {
    beforeEach(() => {
      setMockState({ tasks, totalPages: 5, currentPage: 1, authorized: true })
      renderIt()
      jest.clearAllMocks()
    })

    it('should have paginator', () => {
      screen.getByLabelText('page 1')
      screen.getByLabelText('Go to page 5')
    })

    it('should dispatch index', () => {
      const btn = screen.getByLabelText('Go to page 3')
      userEvent.click(btn)

      expect(indexThunk).toHaveBeenCalledWith({
        order: undefined,
        status: undefined,
        query: '',
        page: 3,
      })
    })
  })

  describe('authorization', () => {
    beforeEach(() => {
      setMockState({ tasks, authorized: false })
      renderIt()
    })

    afterEach(() => jest.clearAllMocks())

    it('should show authorization dialog', () => {
      screen.getByLabelText('authorization dialog')
    })
  })
})
