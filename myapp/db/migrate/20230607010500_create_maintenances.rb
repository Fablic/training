class CreateMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
