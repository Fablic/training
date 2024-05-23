# frozen_string_literal: true

class AddIndexToTitleOnTasks < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :title
  end
end
