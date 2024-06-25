# frozen_string_literal: true

module TasksHelper # rubocop:disable Style/Documentation
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    arrow = column == sort_column ? (sort_direction == 'asc' ? '↑' : '↓') : ''
    link_to "#{title} #{arrow}".html_safe, { sort: column, direction: direction, title: params[:title], status: params[:status] }
  end

  private

  def sort_column
    Task.column_names.include?(params[:sort]) ? params[:sort] : 'unknown'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
