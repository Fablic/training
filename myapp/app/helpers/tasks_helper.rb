module TasksHelper
  def sort_order(column, title)
    type = column == sort_column && sort_type == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, type: type }
  end
end
