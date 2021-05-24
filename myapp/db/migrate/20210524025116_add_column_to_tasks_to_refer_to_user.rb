class AddColumnToTasksToReferToUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :user, null: true, index: true
  end
end
