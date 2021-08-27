import React, { useEffect, useState, useRef } from 'react'
import TextField from '@material-ui/core/TextField'
import Icon from '@material-ui/core/Icon'
import Button from '@material-ui/core/Button'
import IconButton from '@material-ui/core/IconButton'
import Dialog from '@material-ui/core/Dialog'
import DialogActions from '@material-ui/core/DialogActions'
import DialogContent from '@material-ui/core/DialogContent'
import DialogContentText from '@material-ui/core/DialogContentText'
import DialogTitle from '@material-ui/core/DialogTitle'
import { makeStyles } from '@material-ui/core/styles'

import { tasksSlice } from '../state/tasksSlice'
import { useDispatch, useSelector } from 'react-redux'

import { initI18n } from './translation'
import { useTranslation } from 'react-i18next'
const i18n = initI18n()

const SignUp = (props) => {
  const { open, setOpen } = props
  const { t } = useTranslation()
  const dispatch = useDispatch()

  const uidRef = useRef()
  const passwordRef = useRef()

  const [notice, setNotice] = useState(null)

  const submit = async () => {
    const payload = {
      user: {
        uid: uidRef.current.value,
        password: passwordRef.current.value,
      },
    }

    const ret = await fetch('/api/users.json', {
      method: 'POST',
      mode: 'cors',
      crendentials: 'include',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    })

    if (ret.ok) {
      setClose()
    } else {
      const errors = await ret.json()
      setNotice(
        Object.keys(errors)
          .map((k) => errors[k])
          .flat()
      )
    }
  }

  const setClose = () => {
    setOpen(false)
  }

  return (
    <Dialog open={open} onClose={setClose} aria-label="authorization dialog">
      <DialogTitle>{t('authorization.signUp')}</DialogTitle>
      <DialogContent>
        <TextField
          aria-label="user id input"
          autoFocus
          margin="dense"
          label={t('authorization.uid')}
          type="email"
          fullWidth
          inputRef={uidRef}
        />
        <TextField
          aria-label="password input"
          margin="dense"
          label={t('authorization.password')}
          type="password"
          fullWidth
          inputRef={passwordRef}
        />

        {notice && (
          <ul>
            {notice.map((n) => (
              <li key={n}>{n}</li>
            ))}
          </ul>
        )}
      </DialogContent>

      <DialogActions>
        <IconButton onClick={setClose} aria-label="cancel button">
          <Icon>close</Icon>
        </IconButton>
        <IconButton onClick={submit} color="primary" aria-label="signup submit">
          <Icon>person_add</Icon>
        </IconButton>
      </DialogActions>
    </Dialog>
  )
}
export default SignUp
