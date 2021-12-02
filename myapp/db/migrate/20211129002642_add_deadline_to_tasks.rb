class AddDeadlineToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :deadline, :datetime, null: false, default: -> { 'NOW()' }
  end
end
