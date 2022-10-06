# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 255, null: false, comment: 'タスク名'
      t.string :email,            null: false, comment: 'Eメール'
      t.string :password_digest,  null: false, comment: '暗号化されたパスワード'

      t.timestamps
      t.index :email, unique: true
    end
  end
end
