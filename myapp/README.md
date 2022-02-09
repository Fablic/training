# README

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

## app image

![デザイン](docs/step5_appimage.png)

### タスク管理
| 機能 | 概要 |
| --- | --- |
| ログイン | アカウントとパスワードでログインできる |
| サインアップ | ユーザ登録できる |
| タスク一覧 | ログインユーザの登録タスクが一覧できる　　ステータスで絞り込みができる  終了期限や優先順位で並べ替えができる |
| タスク新規登録 | タスク情報（タスク名、内容、終了期限、優先順、ラベル、ステータス）を登録できる |
| タスク編集 | タスク情報を編集できる |
| タスク参照 | タスク情報を参照できる |
| タスク削除 | タスクを削除できる |
| ラベル登録 | ラベルを登録できる |

## models

![モデル](docs/step5_model.png)

### users
| 項目名 | 制約 | Colum | Type | NULL | Default | Options |
| --- | --- | --- | --- | --- | --- | --- |
| ユーザID | PK | id | INT | NOT NULL | -  | unique |
| 名前 | | name | VARCHAR(50) | NOT NULL | -  | - |
| メールアドレス | | email | VARCHAR(256) | NOT NULL | - | unique |
| パスワード | | password | VARCHAR(256) | NOT NULL | - | - |
| 削除フラグ | | deleted | INT | NOT NULL | 0 | - |
| 更新日時 | | modified | DATETIME | NOT NULL | -  | - |
| 作成日時 | | created | DATETIME | NOT NULL | -  | - |

### tasks
| 項目名 | 制約 | Colum | Type | NULL | Default | Options |
| --- | --- | --- | --- | --- | --- | --- |
| タスクID | PK | id | INT | NOT NULL | - | unique |
| ユーザID | FK | user_id | INT | NOT NULL | - | - |
| タスク名 | | title | VARCHAR(128) | NOT NULL | - | - |
| 説明文 | | body | TEXT | NOT NULL | '' | - |
| 終了期限 | | deadline | DATE | NULL | -  | - |
| 優先順位 | | priority | INT | NOT NULL | 2 | - |
| ラベルID | | label_id | INT | NULL | - | - |
| ステータス | | status | INT | NOT NULL | 1 | - |

### labels
| 項目名 | 制約 | Colum | Type | NULL | Default | Options |
| --- | --- | --- | --- | --- | --- | --- |
| ラベルID | PK | id | INT | NOT NULL | -  | unique |
| ラベル名 | FK | label | VARCHAR(50) | NOT NULL | -  | unique |
| カラー | | color | INT | NOT NULL | - | |
