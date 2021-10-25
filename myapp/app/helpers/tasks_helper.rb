# frozen_string_literal: true

module TasksHelper
  def get_sort_direction(sort_name)
    request.params[:direction] == 'ASC' ? 'DESC' : 'ASC'
  end
end
