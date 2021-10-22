# frozen_string_literal: true

class AddIndexTasksUserId < ActiveRecord::Migration[6.1]
  def change
    change_table :tasks, bulk: true do |t|
      t.add_index %i[user_id deleted]
      t.add_index %i[user_id created_at deleted]
      t.add_index %i[user_id due_date_at deleted]
      t.add_index %i[user_id status deleted]
    end
  end
end
