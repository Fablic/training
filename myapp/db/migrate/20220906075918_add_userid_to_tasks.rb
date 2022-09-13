class AddUseridToTasks < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :user, null: false
  end
end
