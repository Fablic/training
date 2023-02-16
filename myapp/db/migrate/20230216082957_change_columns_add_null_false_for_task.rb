class ChangeColumnsAddNullFalseForTask < ActiveRecord::Migration[7.0]
  def up
    change_column :tasks, :name, :string, null: false
  end

  def down
    change_column :tasks, :name, :string, null: true
  end
end
