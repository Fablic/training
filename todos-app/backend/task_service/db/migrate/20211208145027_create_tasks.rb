class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.integer :priority
      t.integer :status
      t.datetime :due_date

      t.timestamps
    end
  end
end
