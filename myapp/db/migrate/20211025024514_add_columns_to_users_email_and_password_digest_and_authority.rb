class AddColumnsToUsersEmailAndPasswordDigestAndAuthority < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :string, null: false
    add_column :users, :password_digest, :string, null: false
    add_column :users, :authority, :integer, limit: 1, null: false, default: 0
  end
end
