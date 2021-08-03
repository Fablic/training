import React, { useEffect, useState, useRef } from 'react'
import Icon from '@material-ui/core/Icon'
import Chip from '@material-ui/core/Chip'
import { makeStyles } from '@material-ui/core/styles'

import { initI18n } from './translation'
import { useTranslation } from 'react-i18next'

const i18n = initI18n()

const StatusChips = (props) => {
  const { onChange, className, status } = props
  const { t } = useTranslation()

  return (
    <>
      <Chip
        icon={<Icon>pending_actions</Icon>}
        aria-label="status-open"
        label={t('status.open')}
        clickable
        className={className}
        color={status == 'open' ? 'primary' : 'default'}
        onClick={() => onChange('open')}
      />
      <Chip
        icon={<Icon>edit</Icon>}
        aria-label="status-in-progress"
        label={t('status.inProgress')}
        clickable
        className={className}
        color={status == 'in_progress' ? 'primary' : 'default'}
        onClick={() => onChange('in_progress')}
      />
      <Chip
        icon={<Icon>done</Icon>}
        aria-label="status-close"
        label={t('status.close')}
        clickable
        className={className}
        color={status == 'close' ? 'primary' : 'default'}
        onClick={() => onChange('close')}
      />
    </>
  )
}
export default StatusChips
