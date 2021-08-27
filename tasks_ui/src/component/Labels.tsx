import React, { useEffect, useState, useRef } from 'react'
import Icon from '@material-ui/core/Icon'
import IconButton from '@material-ui/core/IconButton'
import Chip from '@material-ui/core/Chip'
import { makeStyles } from '@material-ui/core/styles'

import { index, labelsSlice } from '../state/labelsSlice'
import { useDispatch, useSelector } from 'react-redux'

export const LabelChips = (props) => {
  const { labels, className, selected, onClick } = props

  return (
    <>
      {labels &&
        labels.map((label) => (
          <Chip
            {...props}
            aria-label="all labels chip"
            className={className}
            label={label}
            key={label}
            variant="outlined"
            color={label == selected ? 'primary' : 'default'}
            onClick={() => onClick(label)}
          />
        ))}
    </>
  )
}

const Labels = (props) => {
  const dispatch = useDispatch()

  const labels = useSelector((s) => s.labels?.labels)
  const selected = useSelector((s) => s.labels?.selected)
  const authorized = useSelector((s) => s.labels?.authorized)

  useEffect(() => dispatch(index()), [authorized])

  const classes = makeStyles({
    chips: {
      margin: '10px',
      display: 'flex',
      justifyContent: 'center',
      flexWrap: 'wrap',
    },
    chip: {
      margin: '5px',
    },
  })()

  return (
    <div className={classes.chips}>
      <LabelChips
        labels={labels}
        className={classes.chip}
        clickable
        selected={selected}
        onClick={(label) => {
          if (label == selected) {
            dispatch(labelsSlice.actions.select(''))
          } else {
            dispatch(labelsSlice.actions.select(label))
          }
        }}
      />
      <IconButton
        aria-label="all labels update"
        onClick={() => dispatch(index())}
      >
        <Icon>refresh</Icon>
      </IconButton>
    </div>
  )
}
export default Labels
