class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }, limit: 191
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end
