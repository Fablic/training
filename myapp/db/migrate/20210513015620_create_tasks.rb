class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.datetime :due_date, null: true
      t.integer :priority, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
