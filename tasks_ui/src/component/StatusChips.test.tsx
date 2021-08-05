import React from 'react'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { act } from '@testing-library/react-hooks'
import userEvent from '@testing-library/user-event'

import StatusChips from './StatusChips'

describe('StatusChips', () => {
  const onChange = jest.fn()
  const renderIt = (status) => {
    render(<StatusChips onChange={onChange} status={status} />)
  }

  afterEach(() => jest.clearAllMocks())

  it('should have nothing as active with status=null', () => {
    renderIt(null)
    expect(screen.getByLabelText('status-open').className).not.toMatch(
      /MuiChip-clickableColorPrimary/
    )
    expect(screen.getByLabelText('status-in-progress').className).not.toMatch(
      /MuiChip-clickableColorPrimary/
    )
    expect(screen.getByLabelText('status-close').className).not.toMatch(
      /MuiChip-clickableColorPrimary/
    )
  })

  it('should have open as active', () => {
    renderIt('open')
    expect(screen.getByLabelText('status-open').className).toMatch(
      /MuiChip-clickableColorPrimary/
    )
  })

  it('should have in_progress as active', () => {
    renderIt('in_progress')
    expect(screen.getByLabelText('status-in-progress').className).toMatch(
      /MuiChip-clickableColorPrimary/
    )
  })

  it('should have close as active', () => {
    renderIt('close')
    expect(screen.getByLabelText('status-close').className).toMatch(
      /MuiChip-clickableColorPrimary/
    )
  })

  describe('click actions', () => {
    beforeEach(() => renderIt(null))

    it('should call onChange with "open"', () => {
      const chip = screen.getByLabelText('status-open')
      userEvent.click(chip)

      expect(onChange).toHaveBeenCalledWith('open')
    })

    it('should call onChange with "in_progress"', () => {
      const chip = screen.getByLabelText('status-in-progress')
      userEvent.click(chip)

      expect(onChange).toHaveBeenCalledWith('in_progress')
    })

    it('should call onChange with "close"', () => {
      const chip = screen.getByLabelText('status-close')
      userEvent.click(chip)

      expect(onChange).toHaveBeenCalledWith('close')
    })
  })
})
