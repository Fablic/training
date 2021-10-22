# frozen_string_literal: true

module TasksHelper
  def get_sort_direction(sort_name)
    return 'DESC' if request.params[:sort].blank? || (request.params[:sort] != sort_name.to_s)
    return 'DESC' if request.params[:sort] == sort_name.to_s && request.params[:direction] == 'ASC'

    'ASC'
  end
end
