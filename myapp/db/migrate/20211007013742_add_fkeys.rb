class AddFkeys < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :tasks, :users, column: :created_by, name: "fkeyTaskOwner"
    add_foreign_key :labels, :users, column: :created_by, name: "fkeyLabelOwner"
    add_foreign_key :maintenances, :users, column: :created_by, name: "fkeyMaintenanceOwner"

  end
end
