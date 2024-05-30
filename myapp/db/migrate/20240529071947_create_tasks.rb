class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.date :due_date, null: false
      t.integer :priority, null: false, default: 0
      t.datetime :discarded_at

      t.timestamps
    end
    add_index :tasks, :title
    add_index :tasks, :status
    add_index :tasks, :due_date
    add_index :tasks, :priority
  end
end
