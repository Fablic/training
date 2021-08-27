# frozen_string_literal: true

module ApplicationHelper
  def build_sort_link(column, title)
    hash_param = { keyword_name: params[:keyword_name], keyword_progress: params[:keyword_progress] }
    direction = column == params[:sort] && params[:direction] == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction }.merge(hash_param)
  end
end
