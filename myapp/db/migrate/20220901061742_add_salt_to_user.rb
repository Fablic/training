class AddSaltToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :salt, :string
  end
end
