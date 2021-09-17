class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false, limit: 50
      t.text :description, limit: 2000
      t.integer :status, null: false, default: 0, limit: 1
      t.datetime :start_at, null: false
      t.datetime :due_date_at, null: false
      t.integer :deleted, null: false, default: 0, limit: 1

      t.timestamps
    end
  end
end
