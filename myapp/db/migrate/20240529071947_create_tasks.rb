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
    change_table :tasks, bulk: true do |t|
      t.index :status
      t.index :due_date
      t.index :priority
    end
  end
end
