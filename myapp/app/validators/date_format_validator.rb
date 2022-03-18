class DateFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    val = value.split('-').map {|v| v.to_i}
    if val.length != 3 || !Date.valid_date?(*val)
      record.errors.add(attribute, options[:message] || "は型式が違います")
    end
  end
end
