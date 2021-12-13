# frozen_string_literal: true

class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels do |t|
      t.bigint :task_id, comment: 'Task ID'
      t.bigint :label_id, comment: 'Label ID'

      t.timestamps
    end
  end
end
