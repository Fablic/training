# frozen_string_literal: true

class AddSearchIndices < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :name
    add_index :tasks, :status
  end
end
