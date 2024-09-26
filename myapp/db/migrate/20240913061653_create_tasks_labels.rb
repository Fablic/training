class CreateTasksLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks_labels, id: false do |t|
      t.primary_key :id, :unsigned_integer, limit: 8, null: false, auto_increment: true
      t.integer :task_id, unsigned: true, limit: 8, null: false, default: 0
      t.integer :label_id, unsigned: true, limit: 8, null: false, default: 0

      t.timestamps
    end
  end
end
