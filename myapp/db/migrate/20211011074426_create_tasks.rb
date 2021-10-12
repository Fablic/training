class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.string :task_name, limit:20
      t.string :description, limit:100
      t.string :status, limit:10
      t.integer :priority, limit:4
      t.string :label, limit:20
      t.timestamp :start_date
      t.timestamp :end_date
      t.boolean :deleted, default:0
      t.integer :login_id
      t.timestamp :create_dt, default: -> { 'NOW()' }
      t.timestamp :update_dt
    end
  end
end
