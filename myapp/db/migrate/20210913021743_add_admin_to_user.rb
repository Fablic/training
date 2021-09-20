class AddAdminToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :integer, after: :password_digest, null: false, default: 0
  end
end
