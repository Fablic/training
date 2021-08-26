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

import { initI18n } from './translation'
import { useTranslation } from 'react-i18next'
const i18n = initI18n()

const Authorization = (props) => {
  const { t } = useTranslation()

  const uidRef = useRef()
  const passwordRef = useRef()

  const submit = () => {
    const payload = {
      uid: uidRef.current.value,
      password: passwordRef.current.value,
    }

    fetch('/api/users/login.json', {
      method: 'POST',
      mode: 'cors',
      crendentials: 'include',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    })
  }

  return (
    <Dialog open={true} aria-label="authorization dialog">
      <DialogTitle>{t('authorization.title')}</DialogTitle>
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
        <Button>{t('authorization.signUp')}</Button>
      </DialogContent>

      <DialogActions>
        <IconButton onClick={submit} color="primary" aria-label="login submit">
          <Icon>login</Icon>
        </IconButton>
      </DialogActions>
    </Dialog>
  )
}
export default Authorization
