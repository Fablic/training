# frozen_string_literal: true

module TasksHelper
  def display_sort_val(sort_val)
    sort_val&.to_sym.eql?(:desc) ? :asc : :desc
  end
end
