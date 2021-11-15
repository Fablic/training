# frozen_string_literal: true

class CreateMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.boolean :maintenance_on_flag, null: false
      t.timestamps
    end
  end
end
