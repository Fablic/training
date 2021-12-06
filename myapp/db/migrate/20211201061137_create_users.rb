# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 32, comment: '名前'
      t.string :email, limit: 128, unique: true, comment: 'Emailアドレス'
      t.string :password_digest, limit: 255, comment: 'パスワード'

      t.timestamps
    end
  end
end
