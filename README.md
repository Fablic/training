Hello welcome to the Rails Training, here are the links of the training curriculum. Choose the language you prefer.

- [English](steps_en.md)
- [日本語](steps_jp.md)

To start the training first please create a branch with your name (i.e rakuten_taro) from this branch and make that branch as your main branch.
Later when you will send PR, please send PR to your main branch not this or other branches.

## アプリのデザイン
[Figma](https://www.figma.com/file/9BtMi0qocqZu50QK7esxJX/Rails%E7%A0%94%E4%BF%AE%2F%E3%82%BF%E3%82%B9%E3%82%AF%E7%AE%A1%E7%90%86?node-id=0%3A1)でラフデザインを作成しました。
(myapp/docs に画像が入っています)

[メインページ](https://rak.box.com/s/5jxlwcrw9bufvpaimy0s3ockxei4uq9z)
[タスク登録ページ](https://rak.box.com/s/5jxlwcrw9bufvpaimy0s3ockxei4uq9z)

## DB design (step5)

myapp/docs/db_design.mdと同じです。
### users table
| Column | Type | Option |
| ------ | ---- | ------ |
| id | INT | PK |
| name | VARCHAR(64) | NOT NULL |
| email | VARCHAR(256) | NOT NULL |
| password | VARCHAR(256) | NOT MULL |
| is_admin | BOOLEAN | DEFAULT 0 |
| created_at | DATETIME | |
| updated_at | DATETIME | |

### tasks table
| Column | Type | Option |
| ------ | ---- | ------ |
| id | INT | PK |
| title | VARCHAR(64) | NOT NULL |
| description | VARCHAR(256) | |
| user_id | INT | FK |
| priority | INT | |
| status | ENUM("Not Started", "In progress", "Completed") | |
| created_at | DATETIME | |
| updated_at | DATETIME | |

### labels table
| Column | Type | Option |
| ------ | ---- | ------ |
| id | INT | PK |
| name | VARCHAR(64) | NOT NULL |
| created_at | DATETIME | |
| updated_at | DATETIME | |

### tasks_labels table
| Column | Type | Option |
| ------ | ---- | ------ |
| id | INT | PK |
| task_id  | INT | FK |
| label_id | INT | FK |
| created_at | DATETIME | |
| updated_at | DATETIME | |