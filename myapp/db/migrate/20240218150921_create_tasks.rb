class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.string :priority
      t.string :status
      t.datetime :duedate

      t.timestamps
    end
  end
end
