class LimitTitleLengthInTasks < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :title, :string, null: false, limit: 100
  end
end
