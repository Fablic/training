# frozen_string_literal: true

class AddStatusToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :status, :integer
  end
end
