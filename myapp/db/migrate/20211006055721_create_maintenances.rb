# frozen_string_literal: true

class CreateMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.bigint :created_by, null: false
      t.string :name, limit: 256, null: false
      t.timestamp :started_at
      t.timestamp :finished_at

      t.timestamps
    end
  end
end
