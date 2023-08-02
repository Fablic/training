class ChangeTaskStatusAndPriorityDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column_default :tasks, :status, from: nil, to:0
    change_column_default :tasks, :priority, from: nil, to:0
  end
end
