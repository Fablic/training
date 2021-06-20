class ChangeColumnLengthToUsers < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :name, :string, limit: 50, comment: 'ユーザ名を50文字に制限'
  end
end
