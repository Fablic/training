class AddColumnUseridToTasks < ActiveRecord::Migration[6.0]
  def up
    remove_column :tasks, :user_id, :integer
    add_reference :tasks, :user, null: false, foreign_key: true
  end

  def down
    remove_reference :tasks, :user, null: false, foreign_key: true
    add_column :tasks, :user_id, :integer
  end
end
