class AddCascadeOptionToTaskLabel < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :tasks_labels, :tasks
    add_foreign_key :tasks_labels, :tasks, column: :task_id, on_delete: :cascade
  end
end
