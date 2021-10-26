# frozen_string_literal: true

class AddPriority < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :priority, :integer, default: 5
    add_index :tasks, :priority
  end
end
