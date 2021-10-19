class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_digest, :string, comment: '暗号化パスワード', after: :last_login_date
    change_column :users, :mail_address,:string, presence: true
  end
end
