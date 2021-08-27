class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :uid
      t.string :password_hash
      t.string :salt

      t.timestamps
    end
  end
end
