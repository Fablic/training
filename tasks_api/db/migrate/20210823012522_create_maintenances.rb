class CreateMaintenances < ActiveRecord::Migration[6.1]
  def change
    create_table :maintenances do |t|
      t.string :name

      t.timestamps
    end
  end
end
