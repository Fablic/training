class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :priority, limit: 1
      t.integer :status, limit: 1
      t.datetime :due_date

      t.timestamps
    end
  end
end
