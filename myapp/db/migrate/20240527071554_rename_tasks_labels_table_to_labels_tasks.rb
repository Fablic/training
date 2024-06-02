# frozen_string_literal: true

class RenameTasksLabelsTableToLabelsTasks < ActiveRecord::Migration[6.0]
  def change
    rename_table :tasks_labels_tables, :labels_tasks
  end
end
