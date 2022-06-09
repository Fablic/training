class AddExpiredAtToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :expire_at, :time
  end
end
