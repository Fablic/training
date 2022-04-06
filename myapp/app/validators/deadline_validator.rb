class DeadlineValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      deadline = DateTime.new(value.year, value.month, value.day)
      if deadline < Date.today
        record.errors[attribute] << 'は未来日を設定してください。'
      end
    rescue StandardError
      record.errors[attribute] << 'を正しく入力してください。'
    end
  end
end
