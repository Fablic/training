class ChangeDatatypeDueToTask < ActiveRecord::Migration[5.2]
  def up
    change_column :tasks, :due, :date
  end

  def down
    change_column :tasks, :due, :datetime
  end
end
