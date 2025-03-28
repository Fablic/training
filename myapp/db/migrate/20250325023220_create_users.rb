class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :username, null: false
      t.string :password, null: false
      t.boolean :is_admin, null: false, default: false

      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end
