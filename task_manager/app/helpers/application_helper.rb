# frozen_string_literal: true

module ApplicationHelper
  def sortable(column, title, hash_param = {})
    hash_param = {keyword_name: params[:keyword_name], keyword_progress: params[:keyword_progress]}
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction }.merge(hash_param)
  end
end
