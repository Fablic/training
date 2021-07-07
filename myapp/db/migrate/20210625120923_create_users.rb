class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, unique: true
      t.string :password_digest
      t.integer :role
      t.string :name

      t.timestamps
    end
  end
end
