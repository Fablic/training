class AddEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :string, after: :name
    add_index :users, :email, unique: true
  end
end
