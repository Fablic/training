# frozen_string_literal: true

class DateValidator < ActiveModel::Validator
  def validate(record)
    require 'date'

    record.errors[:finished_at] << I18n.t('errors.messages.required') if record.finished_at.blank?

    f = record.finished_at_before_type_cast

    begin
      Date.strptime(f, '%Y-%m-%d')
    rescue StandardError
      record.errors[:finished_at] << I18n.t('messages.invalid_date')
    end

    return if record.started_at.blank?

    s = record.started_at_before_type_cast

    begin
      Date.strptime(s, '%Y-%m-%d')
    rescue StandardError
      record.errors[:started_at] << I18n.t('messages.invalid_date')
    end

    return if record.finished_at.to_date >= record.started_at.to_date

    record.errors.add(:finished_at, I18n.t('earlier_date_error', start: Task.human_attribute_name(:started_at)))
  end
end
