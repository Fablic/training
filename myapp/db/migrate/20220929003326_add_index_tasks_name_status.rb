# frozen_string_literal: true

class AddIndexTasksNameStatus < ActiveRecord::Migration[7.0]
  def change
    add_index :tasks, [:name, :status]
  end
end
