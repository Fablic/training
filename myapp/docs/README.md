
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
first_name, last_nameは削除しました。nameをlogin_nameに変更しました。

| Name         | Index | Nullable | Default | Note            |
| ------------ | ----- | -------- | ------- | --------------- |
| id           |       | no       | | |
| login_name   |   x   | no       | | |
| password     |       | no       | | |
| status       |       | no       | active | active, inactive|
| created_at   |       | no       | | |
| updated_at   |       | no       | | |
| deleted_at   |       | yes      | NULL | |

### tasks

| Name         | Index | Nullable | Default | Note               |
| ------------ | ----- | -------- | ------- | ------------------ |
| id           |       | no       | | |
| user_id      |       | no       | | |
| title        |       | no       | | |
| description  |       | yes      | NULL | |
| status       |   x   | no       | open | open, medium, closed|
| due_date     |       | no       | | |
| priority     |       | no       | high | high, medium, low   |
| created_at   |       | no       | | |
| updated_at   |       | no       | | |
| deleted_at   |       | yes      | NULL | |

### task_to_labels
不要なnameカラムを削除しました。

| Name         | Nullable | Default | Note |
| ------------ | -------- | ------- | ---- |
| id           | no       | | |
| task_id      | no       | | |
| label_id     | no       | | |
| created_at   | no       | | |
| updated_at   | no       | | |
| deleted_at   | yes      | NULL | |

### labels
| Name         | Nullable | Default | Note |
| ------------ | -------- | ------- | ---- |
| id           | no       | | |
| name         | no       | | |
| created_at   | no       | | |
| updated_at   | no       | | |
| deleted_at   | yes      | NULL | |