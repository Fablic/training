class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name , null: false
      t.text :description
      t.string :priority ,null: false
      t.string :status, null: false
      t.date :duedate
      t.timestamps
    end
  end
end
