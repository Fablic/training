class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false, default: 'New Task'
      t.text :description
      t.integer :priority, null: false, default: 0
      t.date :deadline
      t.string :status, null: false, default: 'Not Started'
      t.timestamps
    end
  end
end
