# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.bigint :created_by, null: false
      t.string :name, limit: 256, null: false
      t.text :description
      t.timestamp :started_at
      t.timestamp :finished_at

      t.timestamps
    end
  end
end
