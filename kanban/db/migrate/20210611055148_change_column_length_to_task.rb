class ChangeColumnLengthToTask < ActiveRecord::Migration[6.1]
  def change
    change_column :tasks, :name, :string, limit: 15, comment: "タスク名を15文字に制限"
    change_column :tasks, :description, :string, limit: 50, comment: "タスク詳細を50文字に制限"
  end
end
