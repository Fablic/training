# frozen_string_literal: true

class AddFkeyTaskLabels < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :task_labels, :labels
    add_foreign_key :task_labels, :tasks
  end
end
