class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :mail_address
      t.integer :role_id
      t.datetime :last_login_date
      t.datetime :regist_date
      t.integer :regist_user
      t.datetime :update_date
      t.integer :update_user
      t.boolean :del_flag

      t.timestamps
    end
  end
end
