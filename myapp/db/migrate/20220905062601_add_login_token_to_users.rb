class AddLoginTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :login_token, :string
    add_column :users, :salt, :string, limit: 256, null: false, default: ''
  end
end
