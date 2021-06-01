class CreateTaskLabelAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :task_label_attachments do |t|
      t.references :task, null: false
      t.references :label, null: false
      t.timestamps
      t.index [:task_id, :label_id], unique: true
    end
  end
end
