# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :role, :integer, after: :password_digest, null: false, default: 0,
                                        comment: '役割: 0:一般(ordinary), 1:管理者(admin)'
  end
end
