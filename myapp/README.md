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
* Board information. Board consists 1 kanban board and contains one or more tasks 

| Column      | Type         | Not Null? | PK | default        | description |
|-------------|--------------|--- | --- |----------------|-------------|
| id          | int          | O | O | auto-increment |
| title       | varchar(256) | O | |||

### boards_users
* Boards - Users mapping

| Column   | Type | Not Null? | PK  | default        | description            |
|----------|------|--- |-----|----------------|------------------------|
| board_id | int  | O | O   | |
| user_id  | int  | O | O   |||
| permissions | int | O | | | 1-read 2-write 4-admin |

### tasks
* Each Tasks

  | Column      | Type         | Not Null? | PK | default        | description |
  |-------------|-------------|--------------|--- | --- |----------------|
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

### priorities
* Priority list

| Column      | Type         | Not Null? | PK | default        | description                              |
  |-------------|--------------|--- | --- |------------------------------------------|-------------|
| id          | int          | O | O | auto-increment |
| board_id | int | O | | | board id that this priority is available |
| title       | varchar(32) | O |  |||
| sort       | int | O |  |||

* index: [board_id]

### status_steps
* Status step definition

| Column      | Type         | Not Null? | PK | default        | description |
  |-------------|--------------|--- | --- |----------------|-------------|
| from_status_id          | int          | O | O |  |
| to_status_id       | int | O | O |||

* since from_status_id, to_status_id will be PK, there is no id(auto-increment) column

### statuses
* Status list

| Column   | Type         | Not Null? | PK | default                                | description |
|----------|-------------|--------------|--- |----------------------------------------|----------------|
| id       | int          | O | O | auto-increment                         |
| board_id | int | O | | | board id that this status is available |
| title    | varchar(32) | O |  |||
| sort     | int | O |  |||

* index: [board_id]

### tags_tasks
* Mapper for tags - tasks

  | Column      | Type         | Not Null? | PK | default        | description |
    |-------------|--------------|--- | --- |----------------|-------------|
  | tag_id          | int          | O | O |  |
  | task_id       | int | O | O |||
* since tag_id, task_id will be PK, there is no id(auto-increment) column

### tags
* tag list

  | Column      | Type         | Not Null? | PK | default        | description |
    |-------------|--------------|--- | --- |----------------|-------------|
  | id       | int          | O | O | auto-increment |
  | board_id | int | O | |||
  | tag        | varchar(128) | O | |||
* index: [board_id]
