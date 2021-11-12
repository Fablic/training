# frozen_string_literal: true

module TaskHelper
  def sort_order(column, title)ß
    link_to title, { sort: sort_column, direction: sort_direction }
  end

end
