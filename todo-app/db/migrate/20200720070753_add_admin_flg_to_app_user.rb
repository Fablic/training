# frozen_string_literal: true

class AddAdminFlgToAppUser < ActiveRecord::Migration[6.0]
  def change
    add_column :app_users, :admin, :boolean, default: false
  end
end
