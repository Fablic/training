# frozen_string_literal: true

class AddIndexToTask < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :title
  end
end
