class ChangeDatatypeTitleOfTask < ActiveRecord::Migration[6.0]
  def change
    change_column :tasks, :title, :string, limit: 255
  end
end
