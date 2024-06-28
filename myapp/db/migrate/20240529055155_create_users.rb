class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 0
      t.integer :status, null: false, default: 0

      t.timestamps
    end
    add_index :users, [:name], unique: true
  end
end
