module TaskHelper
  # list sort
  def list_sort_link(name, column_name)
    order = if column_name == sort_target_column
              sort_order == 'asc' ? 'desc' : 'asc'
            else
              'asc'
            end
    link_to name, { sort: column_name, order: order }, id: "order_#{column_name}"
  end
end
