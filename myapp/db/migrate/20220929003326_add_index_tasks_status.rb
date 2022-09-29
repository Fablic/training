# frozen_string_literal: true

class AddIndexTasksStatus < ActiveRecord::Migration[7.0]
  def change
    add_index :tasks, :status
  end
end
