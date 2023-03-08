class AddColumnUserIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_reference :tasks, :user, null: false, index: true, after: :id, foreign_key: true
  end
end
