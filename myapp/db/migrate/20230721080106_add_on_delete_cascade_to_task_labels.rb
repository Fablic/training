class AddOnDeleteCascadeToTaskLabels < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :task_labels, :tasks
    add_foreign_key :task_labels, :tasks, column: :task_id, on_delete: :cascade
  end
end
