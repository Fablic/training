class AddColumnUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :remember_token, :string
  end
end
