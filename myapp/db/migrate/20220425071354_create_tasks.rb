class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.datetime :termination_date
      t.integer :priority
      t.integer :status
      t.integer :label_id

      t.timestamps
    end
  end
end
