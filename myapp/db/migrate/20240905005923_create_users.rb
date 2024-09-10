class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|
      t.primary_key :id, :unsigned_integer, limit: 8, null: false, auto_increment: true
      t.string :name, null: false, limit: 20
      t.string :password_digest, null: false, limit: 72

      t.timestamps
    end
    add_index :users, :name, unique: true
  end
end
