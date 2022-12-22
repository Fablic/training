module DateTimeSelectHelpers
  def select_date(date, options = {})
    raise ArgumentError, 'from is a required option' if options[:from].blank?

    field = options[:from].to_s

    select date.year, from: "#{field}_1i"
    select date.strftime('%B'), from: "#{field}_2i"
    select date.day,  from: "#{field}_3i"
  end
end
