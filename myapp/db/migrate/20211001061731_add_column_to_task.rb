class AddColumnToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :due_date, :datetime, comment: '終了期限', after: :user_id
    change_column :tasks, :name, :string, limit: 256, comment: 'タスク名'
    change_column :tasks, :description, :string, limit: 1024, comment: 'コメント'
  end
end
