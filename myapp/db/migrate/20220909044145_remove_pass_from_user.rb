class RemovePassFromUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :pass
    add_column :users, :password_digest, :string, null: false
  end
end
