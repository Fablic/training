# frozen_string_literal: true

class AddUserToTasks < ActiveRecord::Migration[6.0]
  def up
    add_reference :tasks, :user, null: false, foreign_key: true
  end

  def down
    remove_foreign_key :tasks, :users
    remove_reference :tasks, :user, index: true
  end
end
