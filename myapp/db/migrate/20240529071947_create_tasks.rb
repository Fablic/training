class CreateTasks < ActiveRecord::Migration[6.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description
      t.integer :status, null: false, default: 0
      t.date :due_date, null: false
      t.integer :priority, null: false, default: 0

      t.timestamps
    end
    change_table :tasks, bulk: true do |t|
      t.index :status
    end
  end
end
