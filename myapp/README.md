# README

## アプリケーション名
タスク管理システム
<br>
<br>

## メンテナンスモード
【タスク一覧画面】

開始

docker-compose exec api rails runner Tasks::Maintenancer.start_maintenance(101)

終了

docker-compose exec api rails runner Tasks::Maintenancer.end_maintenance(101)
<br>

【タスク詳細画面】

開始

docker-compose exec api rails runner Tasks::Maintenancer.start_maintenance(102)

終了

docker-compose exec api rails runner Tasks::Maintenancer.end_maintenance(102)
<br>

【タスク作成画面】
開始

docker-compose exec api rails runner Tasks::Maintenancer.start_maintenance(103)

終了

docker-compose exec api rails runner Tasks::Maintenancer.end_maintenance(103)
<br>

【タスク編集画面】
開始

docker-compose exec api rails runner Tasks::Maintenancer.start_maintenance(104)

終了

docker-compose exec api rails runner Tasks::Maintenancer.end_maintenance(104)
<br>
<br>

## 画面設計
【各画面共通】

ログアウトエリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| button　| 1 | ログアウト |  | ボタン | | ログイン画面へ遷移 |
<br>

【タスク一覧画面】

URL
http://localhost:3001

タスク一覧エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| - | 1 | タスク | tasks | オブジェクト | ○ | |
| label | 2 | タスク名 | tasks.name | 文字列 | | |
| label | 2 | ステータス | tasks.status | 文字列 | | コードを文字列へ変換して表示 1:'未着手'、2:'着手中'、3:'完了' |
| label | 2 | 優先度 | tasks.priority | 数値 | | |
| label | 2 | ラベル | labels.name | 文字列 | | タスクに紐づくラベルを全て表示 |
| button | 2 | 詳細 |  | ボタン | | タスク詳細画面へ遷移 |
<br>

検索エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タスク名 | | 文字列 | | 部分一致 |
| select | 1 | ステータス | tasks.status | プルダウン |  | tasks.statusにenumとして設定されている値を全て表示 |
| select | 1 | ラベル | labels.name | プルダウン |  | labelsに登録されているデータを全て表示 |
| button　| 1 | 検索ボタン | | ボタン | | タスク一覧を条件に応じて絞り込み |
<br>

タスク作成エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| button　| 1 | 新規登録 |  | ボタン | | タスク作成画面へ遷移 |
<br>

【タスク詳細画面】

URL
http://localhost:3001/tasks/{task.id}

| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| label | 1 | タスク名 | tasks.title | 文字列 | | |
| label | 1 | 詳細 | tasks.detail | 文字列 | | |
| label | 1 | ステータス | tasks.status | 文字列 | | コードを文字列へ変換して表示 1:'未着手'、2:'着手中'、3:'完了' |
| label | 1 | 優先度 | tasks.priority | 数値 | | |
| label | 1 | ラベル | labels.name | 文字列 | | タスクに紐づくラベルを全て表示 |
| label | 1 | 登録日時 | tasks.created_at | 文字列 | | |
| label | 1 | 更新日時 | tasks.updated_at | 文字列 | | |
| button | 1 | 編集 |  | ボタン | | タスク編集画面へ遷移 |
| button | 1 | 削除 |  | ボタン | | タスクを削除し、タスク一覧画面へ遷移 |
| button | 1 | 一覧へ戻る |  | ボタン | | タスク一覧画面へ遷移 |
<br>

【タスク作成画面】

URL
http://localhost:3001/tasks/new

| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タスク名 | | 文字列 | | |
| text | 1 | 詳細 | | 文字列 | | |
| select | 1 | ステータス | | プルダウン | | 1:'未着手'、2:'着手中'、3:'完了' をリスト表示 |
| select | 1 | 優先度 | | プルダウン | | 1:'低'、2:'中'、3:'高' をリスト表示 |
| select | 1 | ラベル | labels.name | 文字列 | | ラベルを全て表示 |
| button | 1 | 登録 |  | ボタン | | タスク作成 |
| button | 1 | 一覧へ戻る |  | ボタン | | タスク一覧画面へ遷移 |
<br>

【タスク編集画面】

URL
http://localhost:3001/tasks/{task.id}/edit

| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タスク名 | tasks.name | 文字列 | | |
| text | 1 | 詳細 | tasks.detail | 文字列 | | |
| select | 1 | ステータス | プルダウン | 文字列 | | 1:'未着手'、2:'着手中'、3:'完了' をリスト表示 |
| select | 1 | 優先度 | | プルダウン | | 1:'低'、2:'中'、3:'高' をリスト表示 |
| select | 1 | ラベル | labels.name | 文字列 | | ラベルを全て表示 |
| button | 1 | 更新 |  | ボタン | | データを更新 |
| button | 1 | 詳細へ戻る |  | ボタン | | タスク詳細画面へ遷移 |
| button | 1 | 一覧へ戻る |  | ボタン | | タスク一覧画面へ遷移 |
<br>

【ログイン画面】

URL
http://localhost:3001/login

| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | メールアドレス | | 文字列 | | |
| text | 1 | パスワード | | 文字列 | | |
| button | 1 | ログイン |  | ボタン | | ログイン認証 |
<br>

## モデル図
tasks
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| name | varchar | not null | |
| detail | varchar | not null | |
| status | integer | | |
| priority | integer | | |
| created_at | datetime | not null | |
| updated_at | datetime | not null | |

users
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| user_name | varchar | | |
| password | varchar | | |
| email | varchar | | |
| salt | varchar | | |
| created_at | datetime | not null | |
| updated_at | datetime | not null | |

labels
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| label_name | varchar | | |
| created_at | datetime | not null | |
| updated_at | datetime | not null | |

labellings
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| task_id | varchar | not null | |
| label_id | varchar | not null | |
| created_at | datetime | not null | |
| updated_at | datetime | not null | |

maintenances
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| content_id | integer | not null | |
| maintenance_flg | integer | | false |
| created_at | datetime | not null | |
| updated_at | datetime | not null | |

<br>
<br>
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
