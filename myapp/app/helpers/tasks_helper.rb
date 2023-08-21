module TasksHelper
  def link_sort_order(params, sort_by)
    sort_order(params, sort_by) == 'asc' ? 'asc' : 'desc'
  end

  def sort_order(params, sort_by)
    return nil unless params[:sort_by] == sort_by 
    params[:sort_order] == 'asc' ? 'desc' : 'asc'
  end
end
