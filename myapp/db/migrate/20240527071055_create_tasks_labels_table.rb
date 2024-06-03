# frozen_string_literal: true

class CreateTasksLabelsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks_labels_tables do |t|
      t.belongs_to :task
      t.belongs_to :label
    end
  end
end
