# frozen_string_literal: true

class CreateMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.string :reason
      t.datetime :start_datetime
      t.datetime :end_datetime

      t.timestamps
    end
  end
end
