class CreateSystemMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :system_maintenances do |t|
      t.string :key
      t.boolean :maintenance_flg, default: false

      t.timestamps
    end
  end
end
