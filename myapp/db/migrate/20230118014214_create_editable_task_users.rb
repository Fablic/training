class CreateEditableTaskUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :editable_task_users, id: :unsigned_integer do |t|
      t.integer :task_id, null: false, foreign_key: true
      t.integer :user_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
