class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.string :status
      t.string :label
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
