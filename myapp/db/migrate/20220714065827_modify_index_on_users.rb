class ModifyIndexOnUsers < ActiveRecord::Migration[6.0]
  def change
    remove_index :users, name: "index_users_on_name_and_email"
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
  end
end
