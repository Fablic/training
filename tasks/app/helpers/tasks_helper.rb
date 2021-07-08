module TasksHelper
  def sort_order(column, title)
    direction = sort_column == column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, root_path({ sort: column, direction: direction })
  end
end
