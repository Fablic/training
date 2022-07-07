module TasksHelper
  def sort_order(column, name, direction, title, status)
    direction = direction == 'asc' ? 'desc' : 'asc'
    link_to name, { sort: column, order: direction, title: title, status: status }, class: 'btn btn-success btn-sm'
  end

  def parse_date(date)
    date.strftime('%Y/%m/%d %H:%M')
  end
end
