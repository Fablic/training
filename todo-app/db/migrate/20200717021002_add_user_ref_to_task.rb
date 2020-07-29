# frozen_string_literal: true

class AddUserRefToTask < ActiveRecord::Migration[6.0]
  def change
    add_reference :tasks, :app_user, foreign_key: true
  end
end
