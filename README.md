# training project

## データ構造

![ER](./docs/ER.png)

## テーブル

- tasks

| Name        | Type         | NULL     | Unique                           | Desc                           | 
| ----------- | ------------ | -------- | ------------------------------ | ------------------------------ |
| id          | INTEGER      | NOT NULL | unique                    | Primary key|
| user_id          | INTEGER      | NOT NULL |                     ||
| name        | VARCHAR(255) | NOT NULL |                                | |
| description | TEXT         |          |                                | |
| priority    | INTEGER      | NOTNULL  |                                | |
| status      | INTEGER      | NOTNULL  |                                | |
| due_date    | DATETIME     |          |                                | |
| created_at  | DATETIME     | NOTNULL  |                                | |
| updated_at  | DATETIME     | NOTNULL  |                                | |

- labels

| Name        | Type         | NULL    | Unique     | Desc     | 
| ----------- | ------------ | ------- | -------- | -------- |
| id          | INTEGER      | NOTNULL | unique   |Primary key   |
| name        | VARCHAR(255) | NOTNULL | unique   |          | 
| created_at  | DATETIME     | NOTNULL |          |         |
| updated_at  | DATETIME     | NOTNULL |          |        | 

- task_labels

| Name        | Type         | NULL    | Unique     | Desc     |
| ----------- | ------------ | ------- | -------- | -------- | 
| id          | INTEGER      | NOTNULL | unique   |Primary key   |
| task_id     | INTEGER      | NOTNULL |    | Foreign key   | 
| label_id    | INTEGER      | NOTNULL |    | Foreign key   |
| created_at  | DATETIME     | NOTNULL |          |         | 
| updated_at  | DATETIME     | NOTNULL |          |         | 

- users

| Name         | Type         | NULL    | Unique   | Desc   | 
| ------------ | ------------ | ------- | ------ | ------ | 
| id           | INTEGER      | NOTNULL | unique  | Primary key  | 
| name         | VARCHAR(255) | NOTNULL |        |       | 
| email        | VARCHAR(255) | NOTNULL |  unique|        | 
| password     | VARCHAR(255) | NOTNULL |        |        | 
| created_at   | DATETIME     | NOTNULL |        |       | 
| updated_at   | DATETIME     | NOTNULL |        |       | 
