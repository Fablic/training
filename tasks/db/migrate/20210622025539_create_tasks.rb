class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks, id: :integer do |t|
      t.string :task_name, limit:64, null:false
      t.integer :status_id, limit:1, null:false
      t.integer :priority_id, limit:1, null:false
      t.string :label, limit:64, default:nil
      t.datetime :limit_date, limit:6, default:nil
      t.string :detail, limit:255, default:nil
      t.datetime :deleted_at, limit:6, default:nil

      t.timestamps
    end
  end
end
