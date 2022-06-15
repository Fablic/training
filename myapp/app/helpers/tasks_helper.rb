module TasksHelper
  def sort_order(column, title, direction)
    direction = direction == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, order: direction }
  end
end
