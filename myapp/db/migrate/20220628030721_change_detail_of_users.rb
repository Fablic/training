class ChangeDetailOfUsers < ActiveRecord::Migration[6.0]
  def change
    add_index :users, [:name, :email], unique: true
  end
end
