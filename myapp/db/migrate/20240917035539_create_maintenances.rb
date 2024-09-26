class CreateMaintenances < ActiveRecord::Migration[7.0]
  def change
    create_table :maintenances do |t|
      t.integer "is_maintenance", limit: 1, default: 0, null: false, unsigned: true
      t.datetime "started_at"
      t.datetime "ended_at"

      t.timestamps
    end
  end
end
