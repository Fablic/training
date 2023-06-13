class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name, null:false
      t.text :description
      t.integer :priority, null:false
      t.date :expired_date
      t.integer :status, null:false

      t.timestamps
    end
  end
end
