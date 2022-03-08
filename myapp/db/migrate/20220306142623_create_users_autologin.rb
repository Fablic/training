class CreateUsersAutologin < ActiveRecord::Migration[6.0]
  def change
    create_table :users_autologins do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
    add_index :users_autologins, [:token]
  end
end
