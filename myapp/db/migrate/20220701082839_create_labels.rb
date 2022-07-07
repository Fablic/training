class CreateLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :labels do |t|
      t.string :name
      t.timestamps
    end

    create_table :task_labels do |t|
      t.belongs_to :task
      t.belongs_to :label
      t.timestamps
    end
  end
end
