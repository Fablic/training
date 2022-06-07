module TasksHelper
  def sort_order(column)
    column == sort_column && sort_type == 'asc' ? 'desc' : 'asc'
  end

  def sort_type
    %w[asc desc].include?(params[:type]) ? params[:type] : 'desc'
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end
end
