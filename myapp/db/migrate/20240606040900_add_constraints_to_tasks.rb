# frozen_string_literal: true

class AddConstraintsToTasks < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :title, :string, limit: 50
    change_column :tasks, :description, :string, limit: 500
  end

  def down
    change_column :tasks, :title, :string
    change_column :tasks, :description, :text
  end
end
