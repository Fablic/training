class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :integer do |t|
      t.string :user_name, limit:64, null:false
      t.string :email, limit:128, null:false
      t.string :password, limit:128, null:false
      t.boolean :role, null:false
      t.datetime :deleted_at, limit:6, default:nil

      t.timestamps
    end
    add_index :users, [:email], unique:true
  end
end
