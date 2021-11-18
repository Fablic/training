# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :login_id, limit: 10
      t.string :password, limit: 12
      t.string :name, limit: 20
      t.timestamp :created_at, default: -> { 'NOW()' }
      t.timestamp :updated_at
    end
  end
end
