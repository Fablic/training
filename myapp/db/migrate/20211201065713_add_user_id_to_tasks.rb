# frozen_string_literal: true

class AddUserIdToTasks < ActiveRecord::Migration[6.0]
  def change
    change_table :tasks, bulk: true do |t|
      t.bigint :tasks, after: :id, comment: 'Usesr ID'
      t.index :tasks, :user_id, name: 'index_user_id'
    end
  end
end
