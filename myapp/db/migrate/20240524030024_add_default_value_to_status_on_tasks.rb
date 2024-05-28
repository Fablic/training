# frozen_string_literal: true

class AddDefaultValueToStatusOnTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :status, :integer, default: 0
  end
end
