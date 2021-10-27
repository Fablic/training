# frozen_string_literal: true

class DateValidator < ActiveModel::Validator
  def validate(record)
    require 'date'

    return record.errors[:finished_at] << I18n.t('errors.messages.required') if record.finished_at_before_type_cast.blank?
    return record.errors[:finished_at] << I18n.t('messages.invalid_date') unless valid_date_format?(record.finished_at_before_type_cast)

    return if record.started_at_before_type_cast.blank?
    return record.errors[:started_at] << I18n.t('messages.invalid_date') unless valid_date_format?(record.started_at_before_type_cast)

    return if record.finished_at >= record.started_at

    record.errors.add(:finished_at, I18n.t('earlier_date_error', start: Task.human_attribute_name(:started_at)))
  end

  private

  def valid_date_format?(date)
    begin
      Date.strptime(date, '%Y-%m-%d')
    rescue StandardError
      return false
    end
    true
  end
end
