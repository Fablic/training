class CreateMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.integer :content_id, null: false
      t.boolean :maintenance_flg, default: false

      t.timestamps
    end
  end
end
