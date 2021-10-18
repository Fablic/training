# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 256, null: false
      t.string :username, limit: 256, null: false
      t.string :pw, limit: 256, null: false
      t.boolean :first_run, null: false, default: true
      t.boolean :admin, null: false, default: false

      t.timestamps
    end
  end
end
