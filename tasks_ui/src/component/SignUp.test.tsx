import React from 'react'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { act } from '@testing-library/react-hooks'
import userEvent from '@testing-library/user-event'
import { Provider } from 'react-redux'
const fetchMock = require('fetch-mock-jest')

import { store, history } from '../state/store'
import { tasksSlice } from '../state/tasksSlice'
import * as TasksSlice from '../state/tasksSlice'
import * as ReactRedux from 'react-redux'

import SignUp from './SignUp'

const dispatch = jest
  .spyOn(ReactRedux, 'useDispatch')
  .mockImplementation(() => jest.fn())
const setOpen = jest.fn()

describe('SignUp', () => {
  beforeEach(() => render(<SignUp open={true} setOpen={setOpen} />))
  afterEach(() => fetchMock.restore())

  it('should POST /users.json with uid and password', async () => {
    const endpoint = '/api/users.json'
    fetchMock.post(endpoint, {
      status: 200,
      body: '',
    })

    const uid = screen.getByLabelText('user id input').querySelector('input')
    const password = screen
      .getByLabelText('password input')
      .querySelector('input')
    const btn = screen.getByLabelText('signup submit')

    userEvent.type(uid, 'USER ID')
    userEvent.type(password, 'PASSWORD')
    await userEvent.click(btn)

    expect(fetchMock).toHaveFetched()
    waitFor(() => expect(setOpen).toHaveBeenCalledWith(false))
  })
})
