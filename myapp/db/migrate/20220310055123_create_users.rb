class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 45, null: false, comment: '名前'
      t.string :email, limit: 255, null: false, comment: 'メールアドレス'
      t.string :password, limit: 45, null: false, comment: 'パスワード'
      t.integer :deleted, null: false, default: 0, comment: '削除フラグ'

      t.timestamps
    end
  end
end
