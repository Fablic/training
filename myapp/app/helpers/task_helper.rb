# frozen_string_literal: true

module TaskHelper
  def sort_order(column, title)
    link_to title, { sort: column, direction: sort_direction }
  end

end
