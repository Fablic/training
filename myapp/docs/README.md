
# はじめに
以下にタスクアプリの画面設計および、テーブル設計示す。


## 画面設計
<img src="login.jpg" width="160">
<img src="tasks.jpg" width="640">


## テーブル設計
\* はNOT NULL

テーブルは以下の4種類
- users
- tasks
- task_to_labels
- labels

### users
- id *
- name *
- passowrd *
- first_name *
- last_name *
- status (Active, Inactive) *
- created_at
- updated_at
- deleted_at

### tasks
- id *
- user_id *
- title *
- description
- status (Open, Inprogress, Closed) *
- due_date *
- priority (High, Medium, Low) *
- created_at
- updated_at
- deleted_at

### task_to_labels
- id *
- name *
- task_id *
- label_id *
- created_at
- updated_at
- deleted_at

### labels
- id *
- name *
- created_at
- updated_at
- deleted_at