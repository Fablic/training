# frozen_string_literal: true

class CreateTaskLabelRelations < ActiveRecord::Migration[6.0] # rubocop:disable Style/Documentation
  def change
    create_table :task_label_relations do |t|
      t.references :task, null: false, foreign_key: true
      t.references :label, null: false, foreign_key: true

      t.timestamps
    end
  end
end
