class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :unsigned_integer do |t|
      t.string :name, null: false
      t.string :email, null: false, uniq: true
      t.string :password_digest, null: false
      t.boolean :is_admin, null: false, default: false

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
