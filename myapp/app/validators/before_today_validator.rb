class BeforeTodayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    if value.to_date < Date.today
      record.errors.add(attribute, options[:message] || "は今日以降を選択してください")
    end
  end
end
