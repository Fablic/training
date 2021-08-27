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
import { labelsSlice } from '../state/labelsSlice'
import { useDispatch, useSelector } from 'react-redux'

import SignUp from './SignUp'

import { initI18n } from './translation'
import { useTranslation } from 'react-i18next'
const i18n = initI18n()

const Authorization = (props) => {
  const { t } = useTranslation()
  const dispatch = useDispatch()

  const uidRef = useRef()
  const passwordRef = useRef()

  const [signUpOpen, setSignUpOpen] = useState(false)
  const [notice, setNotice] = useState(null)

  const submit = async () => {
    const payload = {
      uid: uidRef.current.value,
      password: passwordRef.current.value,
    }

    const ret = await fetch('/api/users/login.json', {
      method: 'POST',
      mode: 'cors',
      crendentials: 'include',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    })

    if (ret.ok) {
      dispatch(tasksSlice.actions.setAuthorized(true))
      dispatch(labelsSlice.actions.setAuthorized(true))
    } else {
      setNotice(t('authorization.cantLogin'))
    }
  }

  return (
    <>
      <Dialog open={true} aria-label="authorization dialog">
        <DialogTitle>{t('authorization.title')}</DialogTitle>
        <DialogContent>
          <Button onClick={() => setSignUpOpen(true)}>
            {t('authorization.signUp')}
          </Button>

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

          {notice && <div>{notice}</div>}
        </DialogContent>

        <DialogActions>
          <IconButton
            onClick={submit}
            color="primary"
            aria-label="login submit"
          >
            <Icon>login</Icon>
          </IconButton>
        </DialogActions>
      </Dialog>

      <SignUp open={signUpOpen} setOpen={setSignUpOpen} />
    </>
  )
}
export default Authorization
