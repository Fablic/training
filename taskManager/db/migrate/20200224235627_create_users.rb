class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string  :email,           null:false, limit:128
      t.string  :password_digest, null:false
      t.string  :first_name,      null:false, limit:20
      t.string  :last_name,       null:false, limit:20
      t.integer :role,            null:false, limit:1,  default:0
      t.integer :invalid_flg,     null:false, limit:1,  default:0

      t.timestamps
    end
  end
end
