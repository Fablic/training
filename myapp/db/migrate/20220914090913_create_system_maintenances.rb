class CreateSystemMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :system_maintenances do |t|
      t.string :key
      t.string :status, limit: 1, null: false, default: '1'

      t.timestamps
    end
  end
end
