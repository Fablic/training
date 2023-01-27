# テーブル定義書

## users
has_many->tasks  
  
### table
| 論理名 | 物理名 | type | PK | FK | default | not null | 備考 |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| id |  ID  | int | ○ | - | AUTO_INC | × | |
| name | 名前 | varchar | - | - | - | × | |
| email | メールアドレス | varchar | - | - | - | × | |
| encrypted_password | パスワード | varchar | - | - | - | × | hashed |
| created_at | 作成時刻 | datetime | - | - | - | × |  |
| updated_at | 更新時刻 | datetime | - | - | - | × |  |
| authentication_token | 認証トークン | varchar | - | - | null | ○ |  |
| last_sign_in_at | 最終ログイン時刻 | datetime | - | - | null | ○ |  |
| reset_password_token | リセットパスワードトークン | varchar | - | - | null | ○ |  |
| reset_password_sent_at | リセットパスワード送信時刻 | varchar | - | - | null | ○ |  |

### index
| インデックス名 | カラム | フィールド番号 
| ---- | ---- | ---- |
| index_users_on_email | email | 1 |
| index_users_on_authentication_token | authentication_token | 1 |
| index_users_on_reset_password_token | reset_password_token | 1 |
