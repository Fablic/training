# テーブルスキーマ
## users テーブル

| Column          | DataType | Options          | 
| --------------- | -------- | ---------------- | 
| name            | string   | NOT NULL         | 
| email           | string   | NOT NULL         | 
| password_digest | string   | NOT NULL         | 
| admin           | boolean  | DEFAULT false    | 
| created_at      | datetime | CURRENT_DATETIME | 
| updated_at      | datetime | CURRENT_DATETIME | 

## tasks テーブル

| Column     | DataType | Options          | Descripition                          | 
| ---------- | -------- | ---------------- | ------------------------------------- | 
| name       | string   | NOT NULL         |  最大255文字                           | 
| description| text     | NOT NULL         |  最大1024文字                        　| 
| priority   | string   |                  |                                       | 
| status     | string   | NOT NULL         |                                       | 
| deadline   | datetime | NOT NULL         |                                       | 
| user_id    | integer  |                  | usersテーブルの主キーを外部キーとする 　    | 
| created_at | datetime | CURRENT_DATETIME |                                       | 
| updated_at | datetime | CURRENT_DATETIME |                                       | 

## labels テーブル
| Column     | DataType | Options          | Description                           | 
| ---------- | -------- | ---------------- | ------------------------------------- | 
| name       | string   | NOT NULL         |                                       | 
| user_id    | integer  |                  | usersテーブルの主キーを外部キーとする 　    | 
| created_at | datetime | CURRENT_DATETIME |                                       | 

## task_labels  テーブル
| Column     | DataType | Options          | Description                            | 
| ---------- | -------- | ---------------- | -------------------------------------- | 
| task_id    | integer  | PK, NOT NULL     | tasksテーブルの主キーを外部キーとする  　    | 
| label_id   | integer  | PK, NOT NULL     | labelsテーブルの主キーを外部キーとする 　    | 
| created_at | datetime | CURRENT_DATETIME |                                        | 
