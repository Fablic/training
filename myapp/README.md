# テーブルスキーマ
## users テーブル

| Column          | DataType     | Options            | 
| --------------- | ------------ | ------------------ | 
| user_id         | INT          | PK, AUTO_INCREMENT | 
| name            | VARCHAR(255) | NOT NULL           | 
| email           | VARCHAR(255) | NOT NULL           | 
| password_digest | VARCHAR(255) | NOT NULL           | 
| admin           | BOOLEAN      | DEFAULT false      | 
| created_at      | DATETIME     | CURRENT_DATETIME   | 
| updated_at      | DATETIME     | CURRENT_DATETIME   | 

## tasks テーブル

| Column     | DataType     | Options                               | 
| ---------- | ------------ | ------------------------------------- | 
| task_id    | INT          | PK, AUTO_INCREMENT                    | 
| title      | VARCHAR(255) | NOT NULL                              | 
| content    | TEXT         | NOT NULL                              | 
| priority   | VARCHAR(255) |                                       | 
| status     | VARCHAR(255) | NOT NULL                              | 
| due_date   | DATE         | NOT NULL                              | 
| user_id    | INT          | usersテーブルの主キーを外部キーとする | 
| created_at | DATETIME     | CURRENT_DATETIME                      | 
| updated_at | DATETIME     | CURRENT_DATETIME                      | 

## labels テーブル
| Column     | DataType     | Options                               | 
| ---------- | ------------ | ------------------------------------- | 
| label_id   | INT          | PK, AUTO_INCREMENT                    | 
| name       | VARCHAR(255) | NOT NULL                              | 
| user_id    | INT          | usersテーブルの主キーを外部キーとする | 
| created_at | DATETIME     | CURRENT_DATETIME                      | 

## task_labels  テーブル
| Column     | DataType | Options                                | 
| ---------- | -------- | -------------------------------------- | 
| task_id    | INT      | PK                                     | 
| label_id   | INT      | labelsテーブルの主キーを外部キーとする | 
| created_at | DATETIME | CURRENT_DATETIME                       | 