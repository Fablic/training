import React, { useEffect, useState, useRef } from 'react'
import TextField from '@material-ui/core/TextField'
import Icon from '@material-ui/core/Icon'
import IconButton from '@material-ui/core/IconButton'

import { tasksSlice } from '../state/tasksSlice'
import { labelsSlice } from '../state/labelsSlice'
import { useDispatch, useSelector } from 'react-redux'

const Logout = (props) => {
  const dispatch = useDispatch()

  const onLogout = async () => {
    const ret = await fetch('/api/users/logout.json', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: '',
    })

    if (ret.ok) {
      dispatch(tasksSlice.actions.setAuthorized(false))
      dispatch(labelsSlice.actions.setAuthorized(false))
    }
  }

  return (
    <IconButton aria-label="logout button" onClick={onLogout}>
      <Icon>logout</Icon>
    </IconButton>
  )
}
export default Logout
