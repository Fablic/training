class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, unique: true, null: false
      t.string :password_digest, null: false
      t.timestamps
      t.index :email, unique: true
    end
  end
end
