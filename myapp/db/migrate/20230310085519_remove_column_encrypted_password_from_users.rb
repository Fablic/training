class RemoveColumnEncryptedPasswordFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :encrypted_password, :string
  end
end
