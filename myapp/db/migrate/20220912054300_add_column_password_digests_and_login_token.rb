class AddColumnPasswordDigestsAndLoginToken < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_digest, :string, limit: 256, null: false, default: ''
    add_column :users, :salt, :string, limit: 256, null: false, default: ''
    add_column :users, :email, :string, limit: 254, null: false, default: ''
    add_column :users, :login_token, :string
    add_index :users, :password_digest
  end
end
