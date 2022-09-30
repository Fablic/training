class CreateMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.integer :function_id
      t.boolean :maintenance_flag

      t.timestamps
    end
  end
end
