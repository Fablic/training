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
|id|integer|○|PK, 自動連番|
|task_title|varchar(255)|○|タスク名, indexを追加|
|task_content|text|○|タスク内容, indexを追加|
|user_id|integer|○|外部キー, ユーザーID|
|tag_id|varchar(20)||外部キー, タグ|
|due_date|date||終了期限|
|priority|integer|○|優先度, low(0)/medium(1)/high(2)|
|status|integer|○|ステータス, NotReady(0)/Todo(1)/InProgress(2)/Done(3)|
|deleted|integer|○|削除フラグ|
|create_date|datetime|○|登録日時|
|update_date|datetime|○|更新日時|

### User
|Name|Type|NotNULL|Desc|
| :--- | :--- | :--- | :--- |
|id|integer|○|PK, 自動採番|
|user_name|varchar(20)|○|PK, ユーザー名|
|password_digest|string|○|パスワード,Bcryptで暗号化|
|deleted|integrer|○|削除フラグ|
|create_date|datetime|○|登録日時|
|update_date|datetime|○|更新日時|

### Tag
|Name|Type|NotNULL|Desc|
| :--- | :--- | :--- | :--- |
|id|integer|○|PK, 自動採番|
|tag_name|varchar(20)|○|タグ名|
|deleted|integer|○|削除フラグ|
|create_date|datetime|○|登録日時|
|update_date|datetime|○|更新日時|
