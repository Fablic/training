class AddColumnRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :integer, null: false, default: 1
  end
end
