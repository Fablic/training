class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :personal_id, null: false
      t.string :name, null: false
      t.string :pass, null: false

      t.timestamps
    end
  end
end
