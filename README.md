# training project

## データ構造

![ER](./docs/ER.png)

## テーブル

- tasks

| Name        | Type         | NULL     | Desc                           | 
| ----------- | ------------ | -------- | ------------------------------ | 
| id          | INTEGER      | NOT NULL | Primary key                    |
| name        | VARCHAR(255) | NOT NULL |                                | 
| description | TEXT         |          |                                |
| priority    | INTEGER      | NOTNULL  |                                | 
| status      | INTEGER      | NOTNULL  |                                | 
| due_date    | DATETIME     |          |                                | 
| created_at  | DATETIME     | NOTNULL  |                                | 
| updated_at  | DATETIME     | NOTNULL  |                                | 

- labels

| Name        | Type         | NULL    | Desc     | 
| ----------- | ------------ | ------- | -------- | 
| id          | INTEGER      | NOTNULL | Primary key   |
| name        | VARCHAR(255) | NOTNULL |          | 
| created_at  | DATETIME     | NOTNULL |          | 
| updated_at  | DATETIME     | NOTNULL |          | 

- task_labels

| Name        | Type         | NULL    | Desc     | 
| ----------- | ------------ | ------- | -------- | 
| id          | INTEGER      | NOTNULL | Primary key   |
| task_id     | INTEGER      | NOTNULL | Foreign key   | 
| label_id    | INTEGER      | NOTNULL | Foreign key   | 
| created_at  | DATETIME     | NOTNULL |          | 
| updated_at  | DATETIME     | NOTNULL |          | 

- users

| Name         | Type         | NULL    | Desc   | 
| ------------ | ------------ | ------- | ------ | 
| id           | INTEGER      | NOTNULL | Primary key  | 
| name         | VARCHAR(255) | NOTNULL |        | 
| mail         | VARCHAR(255) | NOTNULL |        | 
| password     | VARCHAR(255) | NOTNULL |        | 
| created_at   | DATETIME     | NOTNULL |        | 
| updated_at   | DATETIME     | NOTNULL |        | 