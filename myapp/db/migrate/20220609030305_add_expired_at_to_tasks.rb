class AddExpiredAtToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :expire_at, :datetime, precision: 6
  end
end
