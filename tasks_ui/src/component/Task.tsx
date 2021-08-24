import React, { useEffect, useState, useRef } from 'react'
import { makeStyles } from '@material-ui/core/styles'
import Card from '@material-ui/core/Card'
import CardActions from '@material-ui/core/CardActions'
import CardContent from '@material-ui/core/CardContent'
import IconButton from '@material-ui/core/IconButton'
import Icon from '@material-ui/core/Icon'
import Typography from '@material-ui/core/Typography'
import TextField from '@material-ui/core/TextField'
import Autocomplete from '@material-ui/lab/Autocomplete'
import Chip from '@material-ui/core/Chip'

import DateFnsUtils from '@date-io/date-fns'
import format from 'date-fns/format'
import { ja, enUS } from 'date-fns/locale'
import { MuiPickersUtilsProvider, DatePicker } from '@material-ui/pickers'

import { update, destroy, tasksSlice } from '../state/tasksSlice'
import { index } from '../state/labelsSlice'
import { useDispatch, useSelector } from 'react-redux'

import { initI18n } from './translation'
import { useTranslation } from 'react-i18next'

import StatusChips from './StatusChips'
import { LabelChips } from './Labels'

const i18n = initI18n()

const useStyles = makeStyles({
  input: {
    width: '100%',
  },
  clearButton: {
    margin: '20px 0 0 0',
  },
  cardActions: {
    justifyContent: 'space-between',
  },
  chip: {
    margin: '5px',
  },
})

export class JaDateFnsUtils extends DateFnsUtils {
  getCalendarHeaderText(date: Date) {
    return format(date, 'yyyy MMM', { locale: this.locale })
  }

  getDatePickerHeaderText(date: Date) {
    return format(date, 'MMMd日', { locale: this.locale })
  }
}

const Task: React.FC = (props) => {
  const { task, labels } = props
  const classes = useStyles()

  const [dueDate, setDueDate] = useState(task.dueDate)
  const [status, setStatus] = useState(task.status)
  const [inputLabels, setInputLabels] = useState(task.labels || [])

  const nameRef = useRef()
  const descriptionRef = useRef()

  const dispatch = useDispatch()

  const { t } = useTranslation()

  const onDestroyClick = () => {
    dispatch(destroy({ id: task.id }))
  }

  const fixValues = () => {
    dispatch(
      update({
        ...task,
        name: nameRef.current.value,
        description: descriptionRef.current.value,
        due_date: dueDate,
        labels: inputLabels,
      })
    )
  }

  const updateStatus = (s) => {
    setStatus(s)
    dispatch(
      update({
        ...task,
        status: s,
      })
    )
  }

  let locale = enUS
  let utils = DateFnsUtils
  if (i18n.language == 'ja') {
    locale = ja
    utils = JaDateFnsUtils
  }

  return (
    <Card className={classes.root}>
      <CardContent>
        {!task.edit && (
          <div onClick={() => dispatch(tasksSlice.actions.edit(task.id))}>
            <Typography variant="h5" component="h2" aria-label="name-display">
              {task.name}
            </Typography>
            <Typography
              variant="body2"
              component="div"
              aria-label="description-display"
            >
              {task.description}
            </Typography>
            {task.dueDate && (
              <Typography
                variant="body2"
                component="div"
                aria-label="duedate-display"
              >
                {task.dueDate}
              </Typography>
            )}

            <LabelChips
              labels={task.labels}
              className={classes.chip}
              size={'small'}
            />
          </div>
        )}
        {task.edit && (
          <>
            <div>
              <TextField
                aria-label="name-edit"
                label={t('task_name')}
                className={classes.input}
                defaultValue={task.name}
                inputRef={nameRef}
              />
            </div>
            <div>
              <TextField
                aria-label="description-edit"
                label={t('task_description')}
                className={classes.input}
                defaultValue={task.description}
                inputRef={descriptionRef}
                multiline
              />
            </div>
            <div>
              <MuiPickersUtilsProvider utils={utils} locale={locale}>
                <DatePicker
                  margin="normal"
                  aria-label="dueDate"
                  label={t('due_date')}
                  okLabel={t('ok')}
                  cancelLabel={t('cancel')}
                  format="yyyy/MM/dd"
                  value={dueDate}
                  onChange={setDueDate}
                />
              </MuiPickersUtilsProvider>
              {dueDate && (
                <IconButton
                  onClick={() => setDueDate(null)}
                  className={classes.clearButton}
                >
                  <Icon>clear</Icon>
                </IconButton>
              )}

              <Autocomplete
                multiple
                options={labels}
                defaultValue={task.labels}
                freeSolo
                renderTags={(value: string[], getTagProps) =>
                  value.map((option: string, index: number) => (
                    <Chip
                      variant="outlined"
                      label={option}
                      {...getTagProps({ index })}
                    />
                  ))
                }
                renderInput={(params) => (
                  <TextField
                    {...params}
                    label={t('labels')}
                    placeholder={t('labels')}
                  />
                )}
                onChange={(_, v) => setInputLabels(v)}
              />
            </div>
            <IconButton
              aria-label="fix-button"
              onClick={() => {
                fixValues()
                dispatch(tasksSlice.actions.show(task.id))
              }}
            >
              <Icon>done</Icon>
            </IconButton>
          </>
        )}
      </CardContent>

      <CardActions className={classes.cardActions}>
        <div>
          <StatusChips
            status={task.status}
            onChange={updateStatus}
            className={classes.chip}
          />
        </div>
        <IconButton onClick={onDestroyClick} aria-label="destroy-button">
          <Icon>delete</Icon>
        </IconButton>
      </CardActions>
    </Card>
  )
}

export default Task
