class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mail_address
      t.integer :role_id, limit: 1
      t.datetime :last_login_date
      t.integer :regist_user
      t.integer :update_user
      t.boolean :del_flag, null: false, default: false
      t.timestamps
    end
  end
end
