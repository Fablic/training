class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, limit: 30, null: false
      t.string :detail, limit: 100, null: false
      t.integer :status
      t.integer :priority

      t.timestamps
    end
  end
end
