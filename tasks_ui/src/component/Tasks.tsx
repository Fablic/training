import React, { useEffect, useState, useRef } from 'react'
import Icon from '@material-ui/core/Icon'
import Chip from '@material-ui/core/Chip'
import { makeStyles } from '@material-ui/core/styles'

import { index, tasksSlice } from '../state/tasksSlice'
import { useDispatch, useSelector } from 'react-redux'

import Task from './Task'

const useStyles = makeStyles({
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

  useEffect(() => {
    dispatch(index({ order }))
  }, [order])

  return (
    <>
      <div>
        <Chip
          icon={<Icon>post_add</Icon>}
          aria-label="sort-created"
          label="作成日時"
          clickable
          color={order == null ? 'primary' : 'default'}
          onClick={() => setOrder(null)}
        />
        <Chip
          icon={<Icon>event</Icon>}
          aria-label="sort-due-date"
          label="期限(昇順)"
          clickable
          color={order == 'due_date' ? 'primary' : 'default'}
          onClick={() => setOrder('due_date')}
        />
        <Chip
          icon={<Icon>event</Icon>}
          aria-label="sort-due-date-desc"
          label="期限(降順)"
          clickable
          color={order == 'due_date_desc' ? 'primary' : 'default'}
          onClick={() => setOrder('due_date_desc')}
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
