class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.text :title, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
