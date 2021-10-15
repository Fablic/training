# frozen_string_literal: true

class RenameCreateDtColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :create_dt, :created_at
    rename_column :users, :update_dt, :updated_at
    rename_column :tasks, :create_dt, :created_at
    rename_column :tasks, :update_dt, :updated_at
  end
end
