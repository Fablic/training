class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string  :name, null: false, limit: 191
      t.string  :email, null: false, limit: 191
      t.string  :password_digest, null: false, limit: 191
      t.string  :password_token, limit: 191
      t.timestamps
    end
  end
end
