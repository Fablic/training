class AddEmailToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users, bulk: true do |t|
      t.string :email, null: false, unique: true, after: :name
      t.index :email
    end
  end
end
