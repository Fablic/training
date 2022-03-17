class CreateTasksLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks_labels do |t|
      t.integer :task_id, null: false, comment: 'タスクID'
      t.integer :label_id, null: false, comment: 'ラベルID'
      t.integer :deleted, null: false, default: 0, comment: '削除フラグ'

      t.timestamps
    end
  end
end
