# README

## Table definitions
### users
* Stores user information

| Column      | Type         | Not Null? | PK | default        | description       |
|-------------|--------------|--- | --- |----------------|-------------------|
| id          | int          | O | O | auto-increment |
| email       | varchar(128) | O | |||
| permissions | int          | O | | | 1-login 128-admin |
* index: [email]

### boards
* Board information

| Column      | Type         | Not Null? | PK | default        | description |
|-------------|--------------|--- | --- |----------------|-------------|
| id          | int          | O | O | auto-increment |
| title       | varchar(256) | O | |||

### board_users
* Boards - Users mapping

| Column   | Type | Not Null? | PK  | default        | description            |
|----------|------|--- |-----|----------------|------------------------|
| board_id | int  | O | O   | |
| user_id  | int  | O | O   |||
| permissions | int | O | | | 1-read 2-write 4-admin |

### tasks
* Each Tasks

  | Column      | Type         | Not Null? | PK | default        | description |
-------------|-------------|--------------|--- | --- |----------------|-------------|
  | id          | int          | O | O | auto-increment |
  | board_id    | int | O | |||
  | user_id     | int | O | |||
  | title       | varchar(256) | O | |||
  | contents    | int | O | |||
  | status_id   | int | O | |||
  | priority_id | int | O | |||
  | due_date    | datetime | O | |||
  | created_at  | datetime | O | |||
  | modified_at | datetime | O | |||

* index: [board_id, status_id]

### password_reset_keys
* Password reset key

  | Column      | Type         | Not Null? | PK | default        | description |
    |-------------|--------------|--- | --- |----------------|-------------|
  | reset_key          | varchar(64)          | O | O |  |
  | user_id       | int | O | |||
  | created_at       | datetime | O | |||
  | valid_until       | datetime | O | |||

### priorities
* Priority list

| Column      | Type         | Not Null? | PK | default        | description |
  |-------------|--------------|--- | --- |----------------|-------------|
| id          | int          | O | O | auto-increment |
| board_id       | int | O | |||
| title       | varchar(32) | O | O |||
| sort       | int | O | O |||

* index: [board_id]

### status_steps
* Status step definition

| Column      | Type         | Not Null? | PK | default        | description |
  |-------------|--------------|--- | --- |----------------|-------------|
| from_status_id          | int          | O | O |  |
| to_status_id       | int | O | O |||

### statuses
* Status list

| Column      | Type         | Not Null? | PK | default        | description |
  |-------------|--------------|--- | --- |----------------|-------------|
| id          | int          | O | O | auto-increment |
| board_id       | int | O | |||
| title       | varchar(32) | O |  |||
| sort       | int | O |  |||

* index: [board_id]

### tag_tasks
* Mapper for tags - tasks

  | Column      | Type         | Not Null? | PK | default        | description |
    |-------------|--------------|--- | --- |----------------|-------------|
  | tag_id          | int          | O | O |  |
  | task_id       | int | O | O |||

### tags
* tag list

  | Column      | Type         | Not Null? | PK | default        | description |
    |-------------|--------------|--- | --- |----------------|-------------|
  | id       | int          | O | O | auto-increment |
  | board_id | int | O | |||
  | tag        | varchar(128) | O | |||
* index: [board_id]
