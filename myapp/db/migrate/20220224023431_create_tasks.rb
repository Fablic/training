class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :task_name
      t.string :description
      t.string :status
      t.date :starts_on
      t.date :ends_on
      t.string :priority
      t.string :label

      t.timestamps
    end
  end
end
