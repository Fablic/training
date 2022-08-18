# README

## アプリケーション名
タスク管理システム
<br>

## 画面設計
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
| button | 2 | 詳細 |  | ボタン | | タスク詳細画面へ遷移 |
<br>

タスク作成エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| button　| 1 | 新規登録 |  | ボタン | | タスク作成画面へ遷移 |
<br>

検索エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| select | 1 | 検索方法 | プルダウン | 文字列 |  | 1:'全て'、2:'タスク名'、3:'タスク詳細' |
| text | 1 | 検索フォーム | | 文字列 | | 部分一致 |
| button　| 1 | 検索ボタン | | ボタン | | タスク一覧を条件に応じて絞り込み |
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
| button | 1 | 更新 |  | ボタン | | データを更新 |
| button | 1 | 詳細へ戻る |  | ボタン | | タスク詳細画面へ遷移 |
| button | 1 | 一覧へ戻る |  | ボタン | | タスク一覧画面へ遷移 |
<br>


## モデル図
tasks
column_name | type | null | default
| ---- | ---- | ---- | ---- |
| id | integer | not null | auto increment |
| name | varchar | | |
| detail | varchar | | |
| status | integer | | |
| priority | integer | | |
| created_at | datetime | | |
| updated_at | datetime | | |


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
