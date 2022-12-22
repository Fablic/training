module DateTimeSelectHelpers
  def select_date(field:, date:)
    raise ArgumentError, 'field is a required option' if field.blank?

    date = Date.parse(date) if date.instance_of?(String)

    select date.year, from: "#{field}_1i"
    select date.strftime('%B'), from: "#{field}_2i"
    select date.day,  from: "#{field}_3i"
  end
end
