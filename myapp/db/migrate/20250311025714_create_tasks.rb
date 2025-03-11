class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.bigint :user_id, null: false
      t.integer :priority, null: false, limit: 1
      t.integer :status, null: false, limit: 1
      t.timestamp :deadline

      t.timestamps
    end
  end
end
