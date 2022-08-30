class AddEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :string, limit: 254, null: false, default: ''
  end
end
