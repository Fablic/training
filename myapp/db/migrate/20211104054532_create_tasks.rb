class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :task_name, limit: 20
      t.string :description, limit: 100
      t.string :status, limit: 10
      t.integer :priority, limit: 4
      t.string :label, limit: 20
      t.timestamp :start_date
      t.timestamp :end_date
      t.boolean :deleted, default: 0
      t.integer :login_id

      t.timestamps
    end

    create_table :users do |t|
      t.string :login_id, limit: 10
      t.text :password
      t.string :name, limit: 20
      t.integer :is_admin

      t.timestamps
    end
  end
end
