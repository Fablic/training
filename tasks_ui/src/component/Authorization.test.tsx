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

import Authorization from './Authorization'

const dispatch = jest
  .spyOn(ReactRedux, 'useDispatch')
  .mockImplementation(() => jest.fn())

describe('Authorization', () => {
  beforeEach(() => render(<Authorization />))
  afterEach(() => fetchMock.restore())

  it('should POST /users/login.json with uid and password', async () => {
    const endpoint = '/api/users/login.json'
    fetchMock.post(endpoint, {
      status: 200,
      body: '',
    })

    const uid = screen.getByLabelText('user id input').querySelector('input')
    const password = screen
      .getByLabelText('password input')
      .querySelector('input')
    const btn = screen.getByLabelText('login submit')

    userEvent.type(uid, 'USER ID')
    userEvent.type(password, 'PASSWORD')
    userEvent.click(btn)

    expect(fetchMock).toHaveFetched()
  })
})
