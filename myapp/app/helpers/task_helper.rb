module TaskHelper
  # list sort
  def task_list_sort(name, column_name)
    type = column_name == sort_column && sort_type == 'asc' ? 'desc' : 'asc'
    link_to name, { sort: column_name, type: type }, id: "order_#{column_name}"
  end
end
