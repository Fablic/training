class AddNameToMaintenance < ActiveRecord::Migration[6.0]
  def change
    add_column :maintenances, :name, :string
  end
end
