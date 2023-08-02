class ChangeTaskPrioirtyColumnTypeToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :priority, :integer
  end
end
