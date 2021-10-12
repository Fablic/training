class AddStatusToTask < ActiveRecord::Migration[6.0]
  def up
    add_column :tasks, :status, :integer, comment: '状態', after: :user_id, default: 0
  end
end
