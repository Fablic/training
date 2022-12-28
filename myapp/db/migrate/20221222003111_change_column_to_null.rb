class ChangeColumnToNull < ActiveRecord::Migration[6.0]
  def change
    change_column_null :tasks, :user_id, :tag_id, true
  end
end
