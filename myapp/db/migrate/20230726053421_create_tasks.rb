class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :priority
      t.date :due_date
      t.string :status
      t.references :user, polymorphic: true, null: false
      t.integer :assigned_user_id
      
      t.timestamps
    end
  end
end
