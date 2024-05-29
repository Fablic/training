# frozen_string_literal: true

class AddNotNullConstraintToStatusInTasks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :status, false
  end
end
