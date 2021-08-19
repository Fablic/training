import React, { useEffect, useState, useRef } from 'react'
import Icon from '@material-ui/core/Icon'
import Chip from '@material-ui/core/Chip'
import { makeStyles } from '@material-ui/core/styles'

import { index, labelsSlice } from '../state/labelsSlice'
import { useDispatch, useSelector } from 'react-redux'

const Labels = (props) => {
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

  const dispatch = useDispatch()

  const labels = useSelector((s) => s.labels?.labels)

  useEffect(() => dispatch(index()), [])

  return (
    <div className={classes.chips}>
      {labels &&
        labels.map((label) => (
          <Chip
            aria-label="all labels chip"
            clickable
            className={classes.chip}
            label={label}
            key={label}
            variant="outlined"
          />
        ))}
    </div>
  )
}
export default Labels
