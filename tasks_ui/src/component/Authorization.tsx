import React, { useEffect, useState, useRef } from 'react'
import TextField from '@material-ui/core/TextField'
import Icon from '@material-ui/core/Icon'
import IconButton from '@material-ui/core/IconButton'
import { makeStyles } from '@material-ui/core/styles'

import { initI18n } from './translation'
import { useTranslation } from 'react-i18next'

const Authorization = (props) => {
  return <div aria-label="authorization dialog">unauthorized</div>
}
export default Authorization
