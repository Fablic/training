class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.bigint :user_id, null: false
      t.string :title, null: false
      t.text :body, null: false
      t.date :deadline, null: false
      t.integer :priority, null: false
      t.bigint :label_id, null: true
      t.integer :status, null: false
      t.boolean :deleted, null: false, default: false

      t.timestamps
    end
  end
end
