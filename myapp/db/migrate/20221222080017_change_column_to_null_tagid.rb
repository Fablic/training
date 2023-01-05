class ChangeColumnToNullTagid < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :tag_id, true
  end
end
