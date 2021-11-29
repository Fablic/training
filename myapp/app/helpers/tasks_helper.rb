module TasksHelper
  def sort_order(column, title)
    direction = (column == sort_column && sort_direction == 'asc') ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction }
  end
end
