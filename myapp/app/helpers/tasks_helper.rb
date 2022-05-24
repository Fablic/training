module TasksHelper
  def sort_order(column)
    column == sort_column && sort_type == 'asc' ? 'desc' : 'asc'
  end
end
