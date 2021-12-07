class CreateTaskLabels < ActiveRecord::Migration[6.1]
  def change
    create_table :task_labels do |t|
    end

    add_reference :task_labels, :task, foreign_key: true
    add_reference :task_labels, :label, foreign_key: true
    add_index :task_labels, %i[task_id label_id]
  end
end
