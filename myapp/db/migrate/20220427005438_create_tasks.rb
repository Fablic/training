class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.string :description, :null => false
      t.datetime :termination_at, :null => false
      t.integer :priority, :null => false, limit: 1
      t.integer :status, :null => false, limit: 1

      t.timestamps
    end
  end
end
