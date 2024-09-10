# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks, id: false do |t|
      t.primary_key :id, :unsigned_integer, limit: 8, null: false, auto_increment: true
      t.string :title, limit: 50
      t.string :description, limit: 500

      t.timestamps
    end
  end
end
