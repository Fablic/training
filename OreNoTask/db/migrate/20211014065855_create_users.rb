class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 20
      t.string :password, null: false, limit: 128
      t.integer :privilege, null: false, default: 0, limit: 1
      t.integer :deleted, null: false, default: 0, limit: 1

      t.timestamps
    end
  end
end
