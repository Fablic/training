class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.bigint :created_user_id
      t.integer :priority
      t.integer :status
      t.timestamp :deadline

      t.timestamps
    end
  end
end
