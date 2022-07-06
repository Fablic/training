# frozen_string_literal: true

module TasksHelper
  def sort_order(column, title)
    direction = column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction, keyword: params[:keyword], status: params[:status] }
  end
end
