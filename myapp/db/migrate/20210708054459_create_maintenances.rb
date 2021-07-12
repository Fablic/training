class CreateMaintenances < ActiveRecord::Migration[6.0]
  def change
    create_table :maintenances do |t|
      t.integer :status, limit: 1

      t.timestamps
    end
  end
end
