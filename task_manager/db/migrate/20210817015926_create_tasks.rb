class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.datetime :due_at, null: false
      t.integer :priority, null: false
      t.integer :progress, null: false

      t.timestamps
    end
  end
end
