class CreateUserLoginManagers < ActiveRecord::Migration[6.0]
  def change
    create_table :user_login_managers do |t|
      t.string :remember_token, null:true
      t.string :browser, null:true
      t.string :ip, null:true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
