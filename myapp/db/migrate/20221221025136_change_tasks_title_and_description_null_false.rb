class ChangeTasksTitleAndDescriptionNullFalse < ActiveRecord::Migration[6.0]
  def up
    change_column :tasks, :title, :string, null: false
    change_column :tasks, :description, :string, null: false
  end

  def down
    change_column :tasks, :title, :string
    change_column :tasks, :description, :string
  end
end
