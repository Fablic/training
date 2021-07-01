class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: false do |t|
      t.string :id, limit: 36, null: false, primary_key: true, comment: 'プライマリキー'
      t.string :username, limit: 20, null: false, index: { unique: true }
      t.string :icon
      t.integer :role, default: 0
      t.string :email, limit: 255, null: false, index: { unique: true }
      t.string :password_digest, limit: 255, null: false

      t.timestamps
    end
  end
end
