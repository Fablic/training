class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.datetime :due_date
      t.integer :priority
      t.integer :status
      t.integer :deleted

      t.timestamps
    end
  end
end

class AddIndexToTasks < ActiveRecord::Migration[6.0]
  def change
    add_index :tasks, :title, :content
  end
end