# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.text :password_digest, null: false
      t.boolean :is_admin, default: false, null: false

      t.timestamps
    end
  end
end
