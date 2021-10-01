# frozen_string_literal: true

class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    require 'date'
    begin
      DateTime.new(value.year, value.month, value.day, value.hour, value.min)
    rescue StandardError
      record.errors[attribute] << I18n.t('dictionary.messages.invalid_date')
    end
  end
end
