# frozen_string_literal: true

module TasksHelper # rubocop:disable Style/Documentation
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    arrow = arrow(column)
    link_to "#{title} #{arrow}", { sort: column, direction: direction, title: params[:title], status: params[:status] }
  end

  private

  def arrow(column)
    if column == sort_column
      sort_direction == 'asc' ? '↑' : '↓'
    else
      ''
    end
  end

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'unknown'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
