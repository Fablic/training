class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 50
      t.string :email, null: false, index: { unique: true }
      t.string :password, null: false
      t.integer :admin_flg, null: false, default: 0
      t.timestamps
    end
  end
end
