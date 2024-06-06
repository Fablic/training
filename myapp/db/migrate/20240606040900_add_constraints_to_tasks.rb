# frozen_string_literal: true

class AddConstraintsToTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :title, :string, limit: 50
    change_column :tasks, :description, :text, limit: 500
  end
end
