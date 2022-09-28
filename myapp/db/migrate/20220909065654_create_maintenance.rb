class CreateMaintenance < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.integer :service_id
      t.boolean :maintenance_flg, default: false

      t.timestamps
    end
  end
end
