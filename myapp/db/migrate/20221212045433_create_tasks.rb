class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :priority
      t.integer :status
      t.datetime :due_date

      t.timestamps
    end
  end
end
