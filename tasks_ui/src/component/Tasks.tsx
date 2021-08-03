import React, { useEffect, useState, useRef } from 'react'
import Icon from '@material-ui/core/Icon'
import Chip from '@material-ui/core/Chip'
import { makeStyles } from '@material-ui/core/styles'

import { index, tasksSlice } from '../state/tasksSlice'
import { useDispatch, useSelector } from 'react-redux'

import Task from './Task'
import StatusChips from './StatusChips'
import { initI18n } from './translation'
import { useTranslation } from 'react-i18next'

const i18n = initI18n()

const useStyles = makeStyles({
  chips: {
    margin: '10px',
    display: 'flex',
    justifyContent: 'center',
  },
  chip: {
    margin: '5px',
  },
  ol: {
    padding: 0,
  },
  li: {
    listStyleType: 'none',
    margin: '10px',
  },
})

const Tasks: React.FC = (props) => {
  const tasks = useSelector((s) => s.tasks.tasks)
  const dispatch = useDispatch()

  const classes = useStyles()

  const [order, setOrder] = useState()
  const [status, setStatus] = useState()

  const { t } = useTranslation()

  useEffect(() => {
    dispatch(index({ order, status }))
  }, [order, status])

  const changeStatus = (newStatus) => {
    if (status == newStatus) {
      setStatus(null)
    } else {
      setStatus(newStatus)
    }
  }

  return (
    <>
      <div className={classes.chips}>
        <Chip
          icon={<Icon>post_add</Icon>}
          aria-label="sort-created"
          label={t('order.createdAt')}
          clickable
          className={classes.chip}
          color={order == null ? 'primary' : 'default'}
          onClick={() => setOrder(null)}
        />
        <Chip
          icon={<Icon>event</Icon>}
          aria-label="sort-due-date"
          label={t('order.dueDate')}
          clickable
          className={classes.chip}
          color={order == 'due_date' ? 'primary' : 'default'}
          onClick={() => setOrder('due_date')}
        />
        <Chip
          icon={<Icon>event</Icon>}
          aria-label="sort-due-date-desc"
          label={t('order.dueDateDesc')}
          clickable
          className={classes.chip}
          color={order == 'due_date_desc' ? 'primary' : 'default'}
          onClick={() => setOrder('due_date_desc')}
        />
      </div>

      <div className={classes.chips}>
        <StatusChips
          className={classes.chip}
          onChange={changeStatus}
          status={status}
        />
      </div>

      <ol className={classes.ol}>
        {tasks.map((t) => (
          <li key={t.id} className={classes.li}>
            <Task task={t} />
          </li>
        ))}
      </ol>
    </>
  )
}
export default Tasks
