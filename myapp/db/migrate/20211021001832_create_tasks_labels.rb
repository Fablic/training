class CreateTasksLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels_tasks do |t|
      t.belongs_to :task, null: false, foreign_key: true, index: true
      t.belongs_to :label, null: false, foreign_key: true, index: true
    end
  end
end
