class CreateTaskLabelLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :task_label_links do |t|
      t.belongs_to :task, index: true
      t.belongs_to :label, index: true

      t.timestamps
    end
  end
end
