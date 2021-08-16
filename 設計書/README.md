### 設計書


### Database
- tasks

| Name        | Type         | NULL     | Desc                           | 
| ----------- | ------------ | -------- | ------------------------------ | 
| id          | INTEGER      | NOT NULL | 主キー                         | 
| user_id     | INTEGER      | NOTNULL  | 外部キー,userがない場合、id=0  | 
| label_id | INTEGER      | NOTNULL  | 外部キー,特になにもない場合は0 | 
| name        | VARCHAR(255) | NOTNULL  |                                | 
| description | VARCHAR(255) |          |                                | 
| due_at      | DATETIME     | NOTNULL  |                                | 
| priority    | INTEGER      | NOTNULL  | low(0)/normal(1)/high(2)       | 
| progress    | INTEGER      | NOTNULL  | Todo(0)/InProgress(1)/Done(2)  | 
| created_at  | DATETIME     | NOTNULL  |                                | 
| updated_at  | DATETIME     | NOTNULL  |                                | 

- labels

| Name        | Type         | NULL    | Desc     | 
| ----------- | ------------ | ------- | -------- | 
| id          | INTEGER      | NOTNULL | 主キー   | 
| task_id     | INTEGER      | NOTNULL | 外部キー | 
| description | VARCHAR(255) | NOTNULL |          | 
| created_at  | DATETIME     | NOTNULL |          | 
| updated_at  | DATETIME     | NOTNULL |          | 

- label_to_task

| Name       | Type         | NULL    | Desc     | 
| ---------- | ------------ | ------- | -------- | 
| id         | INTEGER      | NOTNULL | 主キー   | 
| task_id    | INTEGER      | NOTNULL | 外部キー | 
| label_id   | VARCHAR(255) | NOTNULL | 外部キー | 
| created_at | DATETIME     | NOTNULL |          | 
| updated_at | DATETIME     | NOTNULL |          | 

- user

| Name         | Type         | NULL    | Desc   | 
| ------------ | ------------ | ------- | ------ | 
| id           | INTEGER      | NOTNULL | 主キー | 
| mail_address | INTEGER      | NOTNULL |        | 
| password     | VARCHAR(255) | NOTNULL |        | 
| created_at   | DATETIME     | NOTNULL |        | 
| updated_at   | DATETIME     | NOTNULL |        | 
