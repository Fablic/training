# frozen_string_literal: true

class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :task_labels do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_reference :task_labels, :task, foreign_key: true
  end
end
