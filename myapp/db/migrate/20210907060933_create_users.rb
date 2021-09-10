class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.text :password_digest, null: false

      t.timestamps
      t.index :name, unique: true
    end

    add_reference :tasks, :user, foreign_key: true, after: :id

  end
end
