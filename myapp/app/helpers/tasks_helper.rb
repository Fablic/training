# frozen_string_literal: true

module TasksHelper
  def sort_val_helper(sort_val)
    #to_sym converts string to symbol (i.e: "a".to_sym => :a)
    sort_val&.to_sym.eql?(:desc) ? :asc : :desc
  end
end
