# README

## アプリケーション名
タスク管理システム
<br>


## メンテナンスモード
【タスク一覧画面】

開始

docker-compose exec api rails runner "Tasks::Maintenancer.start(1)"

終了

docker-compose exec api rails runner "Tasks::Maintenancer.end(1)"
<br>

【タスク詳細画面】

開始

docker-compose exec api rails runner "Tasks::Maintenancer.start(2)"

終了

docker-compose exec api rails runner "Tasks::Maintenancer.end(2)"
<br>

【タスク作成画面】

開始

docker-compose exec api rails runner "Tasks::Maintenancer.start(3)"

終了

docker-compose exec api rails runner "Tasks::Maintenancer.end(3)"
<br>

【タスク編集画面】
開始

docker-compose exec api rails runner "Tasks::Maintenancer.start(4)"

終了

docker-compose exec api rails runner "Tasks::Maintenancer.end(4)"
<br>
<br>

## 画面設計

【共通部品】

ログアウトエリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| button　| 1 | ログアウト |  | ボタン | | ログアウト処理を実施し、ログイン画面へ遷移 |
<br>

【タスク一覧画面】

URL
http://localhost:3001

タスク一覧エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| - | 1 | タスク | tasks | オブジェクト | ○ | |
| label | 2 | タスク名 | tasks.name | 文字列 | | |
| label | 2 | ステータス | tasks.status | 文字列 | | コードを文字列へ変換して表示 1:'未着手'、2:'実施中'、3:'完了' |
| label | 2 | ラベル | labels.name | 文字列 | | |
| button | 2 | 詳細 |  | ボタン | | タスク詳細画面へ遷移 |
<br>

タスク作成エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| button　| 1 | 新規作成 |  | ボタン | | タスク作成画面へ遷移 |
<br>

検索エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タスク名 | | 文字列 | | 部分一致 |
| select | 1 | ステータス | tasks.status.enum | プルダウン | | |
| select | 1 | ラベル | labels.name | プルダウン | | |
| button　| 1 | 検索ボタン | | ボタン | | 検索条件をもとにタスク一覧を絞り込む |
<br>

【タスク詳細画面】

URL
http://localhost:3001/tasks/{task.id}

| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| label | 1 | タスク名 | tasks.title | 文字列 | | |
| label | 1 | 詳細 | tasks.description | 文字列 | | |
| label | 1 | ステータス | tasks.status | 文字列 | | コードを文字列へ変換して表示 1:'未着手'、2:'実施中'、3:'完了' |
| label | 1 | ラベル | labels.name | 文字列 | | |
| label | 1 | 登録日時 | tasks.created_at | 文字列 | | |
| label | 1 | 更新日時 | tasks.updated_at | 文字列 | | |
| button | 1 | 編集 |  | ボタン | | タスク編集画面へ遷移 |
| button | 1 | 削除 |  | ボタン | | タスクを削除し、タスク一覧画面へ遷移 |
| button | 1 | 戻る |  | ボタン | | タスク一覧画面へ遷移 |
<br>

【タスク作成画面】

URL
http://localhost:3001/tasks/new

| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タスク名 | | 文字列 | | |
| text | 1 | 詳細 | | 文字列 | | |
| select | 1 | ステータス | プルダウン | 文字列 | | 1:'未着手'、2:'実施中'、3:'完了' をリスト表示 |
| select | 1 | ラベル | labels.name | 文字列 | | ラベルを全て表示 |
| button | 1 | タスクを作成 |  | ボタン | | タスク作成 |
| button | 1 | 戻る |  | ボタン | | タスク一覧画面へ遷移 |
<br>

【タスク編集画面】

URL
http://localhost:3001/tasks/{task.id}/edit

| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タスク名 | tasks.name | 文字列 | | |
| text | 1 | 詳細 | tasks.description | 文字列 | | |
| select | 1 | ステータス | プルダウン | 文字列 | | 1:'未着手'、2:'実施中'、3:'完了' をリスト表示 |
| select | 1 | ラベル | labels.name | 文字列 | | ラベルを全て表示 |
| button | 1 | タスクを更新 |  | ボタン | | データを更新 |
| button | 1 | 詳細へ |  | ボタン | | タスク詳細画面へ遷移 |
<br>

【ログイン画面】

URL
http://localhost:3001/login

| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | メールアドレス | | 文字列 | | |
| text | 1 | パスワード | | 文字列 | | |
| button | 1 | ログイン |  | ボタン | | ログイン認証を実施 |
<br>

## モデル図
labellings
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| task_id | varchar | | |
| label_id | varchar | | |
| created_at | datetime | | |
| updated_at | datetime | | |
<br>

labels
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| name | varchar | | |
| created_at | datetime | | |
| updated_at | datetime | | |
<br>

tasks
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| name | varchar | | |
| description | varchar | | |
| status | integer | | |
| created_at | datetime | | |
| updated_at | datetime | | |
<br>

users
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| user_name | varchar | | |
| password | varchar | | |
| email | varchar | | |
| salt | varchar | | |
| created_at | datetime | | |
| updated_at | datetime | | |
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
