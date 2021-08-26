import React, { useEffect, useState, useRef } from 'react'
import Icon from '@material-ui/core/Icon'
import Chip from '@material-ui/core/Chip'
import Input from '@material-ui/core/Input'
import InputLabel from '@material-ui/core/InputLabel'
import InputAdornment from '@material-ui/core/InputAdornment'
import FormControl from '@material-ui/core/FormControl'
import IconButton from '@material-ui/core/IconButton'
import Pagination from '@material-ui/lab/Pagination'
import { makeStyles } from '@material-ui/core/styles'

import { index, tasksSlice } from '../state/tasksSlice'
import { useDispatch, useSelector } from 'react-redux'

import Task from './Task'
import StatusChips from './StatusChips'
import Authorization from './Authorization'
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
  search: {
    display: 'flex',
    justifyContent: 'center',
  },
  paginator: {
    display: 'flex',
    justifyContent: 'center',
  },
})

const Tasks: React.FC = (props) => {
  const authorized = useSelector((s) => s.tasks.authorized)
  const tasks = useSelector((s) => s.tasks.tasks)
  const totalPages = useSelector((s) => s.tasks.totalPages)
  const page = useSelector((s) => s.tasks.currentPage)
  const labels = useSelector((s) => s.labels.labels)
  const selectedLabel = useSelector((s) => s.labels.selected)

  const dispatch = useDispatch()

  const classes = useStyles()

  const [order, setOrder] = useState()
  const [status, setStatus] = useState()
  const [searchword, setSearchword] = useState('')
  const [query, setQuery] = useState('')

  const searchRef = useRef()

  const { t } = useTranslation()

  const updateList = (params) => {
    dispatch(index(params))
  }

  useEffect(() => {
    updateList({ order, status, query, page, label: selectedLabel })
  }, [order, status, query, selectedLabel])

  const changeStatus = (newStatus) => {
    if (status == newStatus) {
      setStatus(null)
    } else {
      setStatus(newStatus)
    }
  }

  return (
    <>
      {!authorized && <Authorization />}

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
      <div className={classes.search}>
        <FormControl>
          <InputLabel htmlFor="searchword">{t('search')}</InputLabel>
          <Input
            aria-label="search input"
            id="searchword"
            type="text"
            value={searchword}
            inputRef={searchRef}
            onChange={() => setSearchword(searchRef.current.value)}
            endAdornment={
              <>
                {searchword.length > 0 && (
                  <InputAdornment position="end">
                    <IconButton
                      aria-label="clear searchword"
                      onClick={() => {
                        setSearchword('')
                        setQuery('')
                      }}
                      edge="end"
                    >
                      <Icon>backspace</Icon>
                    </IconButton>
                  </InputAdornment>
                )}
                <InputAdornment position="end">
                  <IconButton
                    onClick={() => setQuery(searchRef.current.value)}
                    aria-label="search button"
                  >
                    <Icon>search</Icon>
                  </IconButton>
                </InputAdornment>
              </>
            }
          />
        </FormControl>
      </div>

      <ol className={classes.ol}>
        {tasks.map((t) => (
          <li key={t.id} className={classes.li}>
            <Task task={t} labels={labels} />
          </li>
        ))}
      </ol>

      <Pagination
        className={classes.paginator}
        count={totalPages}
        page={page}
        onChange={(_, n) => updateList({ order, status, query, page: n })}
      />
    </>
  )
}
export default Tasks
