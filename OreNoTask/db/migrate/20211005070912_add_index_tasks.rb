# frozen_string_literal: true

class AddIndexTasks < ActiveRecord::Migration[6.1]
  def change
    add_index :tasks, :deleted
    add_index :tasks, [:created_at, :deleted]
    add_index :tasks, [:due_date_at, :deleted]
    add_index :tasks, [:status, :deleted]
  end
end
