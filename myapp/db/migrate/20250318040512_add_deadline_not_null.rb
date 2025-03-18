class AddDeadlineNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :tasks, :deadline, false
  end
end
