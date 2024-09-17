class AddFkToTasksLabels < ActiveRecord::Migration[7.0]
  def up
    add_foreign_key :tasks_labels, :tasks
    add_foreign_key :tasks_labels, :labels
  end

  def down
    remove_foreign_key :tasks_labels, :tasks, if_exists: true
    remove_foreign_key :tasks_labels, :labels, if_exists: true
  end
end
