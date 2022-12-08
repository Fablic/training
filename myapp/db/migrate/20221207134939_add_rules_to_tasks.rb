# frozen_string_literal: true

class AddRulesToTasks < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :title, :string, null: false, limit: 40
  end

  def down
    change_column :tasks, :title, :string, null: true
  end
end
