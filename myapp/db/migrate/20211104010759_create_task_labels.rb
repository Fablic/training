# frozen_string_literal: true

class CreateTaskLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_reference :labels, :user, foreign_key: true, null: false

    create_table :task_labels do |t|
      t.belongs_to :task, null: false
      t.belongs_to :label, null: false
      t.timestamps
    end
  end
end
