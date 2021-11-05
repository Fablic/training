# frozen_string_literal: true
class AddIndexTasksTitleAndStatus < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, [:title, :status]
  end
end
