class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :password, null: false
      t.text :description

      t.timestamps
    end

    add_reference :tasks, :user, null: false, foreign_key: false
  end
end
