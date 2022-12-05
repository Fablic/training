# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
2.6.10  
* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## Table schema

### Task
|Name|Type|NotNULL|Desc|
| :--- | :--- | :--- | :--- |
|TASK_NO|INTEGER|○|PK, タスク連番(自動採番)|
|TASK_TITLE|VARCHAR(255)|○|タスク名|
|TASK_CONTENT|TEXT|○|タスク内容|
|USER_ID|VARCHAR(20)|○|外部キー, ユーザーID|
|TAG_NO|VARCHAR(20)||外部キー, タグ|
|DUE_DATE|DATE||終了期限|
|PRIORITY|INTEGER|○|優先度|
|STATUS|INTEGER|○|ステータス|
|DETETED|INTEGER|○|削除フラグ|
|CREATE_DATE|DATETIME|○|登録日時|

### User
|Name|Type|NotNULL|Desc|
| :--- | :--- | :--- | :--- |
|USER_NO|INTEGER|○|PK, ユーザー連番(自動採番)|
|USER_ID|VARCHAR(20)|○|PK, ユーザーID|
|PASSWORD|VARCHAR(15)|○|パスワード|
|DELETED|INTEGER|○|削除フラグ|
|CREATE_DATE|DATETIME|○|登録日時|

### Tag
|Name|Type|NotNULL|Desc|
| :--- | :--- | :--- | :--- |
|TAG_NO|INTEGER|○|PK, タグ連番(自動採番)|
|TAG_NAME|VARCHAR(20)|○|タグ名|
|DELETED|INTEGER|○|削除フラグ|
|CREATE_DATE|DATETIME|○|登録日時|
