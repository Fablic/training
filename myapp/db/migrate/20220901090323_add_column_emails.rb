class AddColumnEmails < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email, :string, limit: 128, null: false, unique: true
  end
end
