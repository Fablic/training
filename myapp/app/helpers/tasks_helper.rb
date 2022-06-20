module TasksHelper
  def sort_order(column, name, direction, title, status)
    direction = direction == 'asc' ? 'desc' : 'asc'
    link_to name, { sort: column, order: direction, title: title, status: status }
  end

  def parse_date(date)
    return date.strftime("%Y/%m/%d %H:%M")
  end
end
