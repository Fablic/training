class DropUsers < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :tasks, :users
    drop_table :users do |t|
      t.string "name"
      t.string "password_digest"
    end
  end
end
