# frozen_string_literal: true

module TasksHelper
  def sort_link(column_name)
    output = link_to_unless_current('▲', root_path(take_search_params(column_name, :asc)))
    output << link_to_unless_current('▼', root_path(take_search_params(column_name, :desc)))
  end

  def admin_sort_link(user, column_name)
    output = link_to_unless_current('▲', tasks_admin_user_path(user, take_search_params(column_name, :asc)))
    output << link_to_unless_current('▼', tasks_admin_user_path(user, take_search_params(column_name, :desc)))
  end

  def take_search_params(sort_column, direction)
    {
      sort_column:    sort_column,
      sort_direction: direction,
      name:           params[:name],
      status:         params[:status],
      page:           params[:page],
    }
  end
end
