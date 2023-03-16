class AddColumnAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :admin, :boolean, null: false, default: false, after: :password_digest
  end
end
