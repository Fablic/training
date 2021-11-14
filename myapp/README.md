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

| Column     | DataType | Options                               | 
| ---------- | -------- | ------------------------------------- | 
| title      | string   | NOT NULL                              | 
| content    | text     | NOT NULL                              | 
| priority   | string   |                                       | 
| status     | string   | NOT NULL                              | 
| due_date   | date     | NOT NULL                              | 
| user_id    | integer  | usersテーブルの主キーを外部キーとする | 
| created_at | datetime | CURRENT_DATETIME                      | 
| updated_at | datetime | CURRENT_DATETIME                      | 

## labels テーブル
| Column     | DataType | Options                               | 
| ---------- | -------- | ------------------------------------- | 
| name       | string   | NOT NULL                              | 
| user_id    | integer  | usersテーブルの主キーを外部キーとする | 
| created_at | datetime | CURRENT_DATETIME                      | 

## task_labels  テーブル
| Column     | DataType | Options                                | 
| ---------- | -------- | -------------------------------------- | 
| task_id    | integer  | PK                                     | 
| label_id   | integer  | labelsテーブルの主キーを外部キーとする | 
| created_at | datetime | CURRENT_DATETIME                       | 