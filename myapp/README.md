# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Database design

<br>

tasks
| column_name | type | null | default |
| ---- | ---- | ---- | ---- |
| id | integer(20) | not null | auto_increment |
| title | varchar(128) | not null | '' |
| content | varchar(1024) | | |
| user_id | integer | | |
| status | varchar(1) | not null | '1' |
| label | varchar(64) | | |
| deleted_at | datetime | | |
| created_at | datetime | | |
| updated_at | datetime | | |

※statusについて
1:未着手、2:着手中、3:完了
※結合キー
user_id:N　→ users.id:1
id:1　→ labels.task_id:N
<br>

labels
| column_name | type | null | default |
| ---- | ---- | ---- | ---- |
| id | integer(20) | not null | auto_increment |
| name | varchar(64) | not null | '' |
| task_id | integer | | |
| deleted_at | datetime | | |
| created_at | datetime | | |
| updated_at | datetime | | |

※結合キー
task_id:N　→ tasks.id:1
<br>

users
| column_name | type | null | default |
| ---- | ---- | ---- | ---- |
| id | integer(20) | not null | auto_increment |
| name | varchar(128) | not null | '' |
| password_digest | varchar(256) | not null | '' |
| salt | varchar(256) | not null | '' |
| email | varchar(254) | not null | '' |
| deleted_at | datetime | | |
| created_at | datetime | | |
| updated_at | datetime | | |

※結合キー
id:1　→ tasks.user_id:N
<br>

functions
| column_name | type | null | default |
| ---- | ---- | ---- | ---- |
| id | integer(20) | not null | auto_increment |
| name | varchar(64) | | |
| status | varchar(1) | not null | '1' |
| deleted_at | datetime | | |
| created_at | datetime | | |
| updated_at | datetime | | |

※statusについて
1:開始中、9:停止中
<br>

* Screen design

実際に画面設計した方がよいのだと思いますが、こちらに外部設計を模した設計として各画面の設計を記載します。
必要であれば、他ツールでワイヤフレーム作成します。
<br>
【タスク一覧画面】
URL:
　/

表示：

タスク作成エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| button　| 1 | 作成ボタン |  | ボタン | | タスク作成画面へ遷移 |

<br>

検索エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| select | 1 | ラベル | tasks.label | 文字列 |  | tasks.label全て（重複除外）、五十音順 |
| text | 1 | タイトル検索フォーム | | 文字列 | | 部分一致、128文字まで |
| button　| 1 | 検索ボタン |  | ボタン | | タスク一覧を条件に応じて絞り込み |

<br>

タスク一覧エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| - | 1 | タスク | tasks + users | オブジェクト | ○ | tasksとusersを結合したオブジェクトリスト、作成日順 |
| label | 2 | タイトル | tasks.title | 文字列 | | |
| label | 2 | ラベル | labels.name | 文字列 | | 複数表示 |
| label | 2 | 状況 | tasks.status | 文字列 | | コードを文字列へ変換して表示 1:'未着手'、2:'着手中'、3:'完了' |
| button | 2 | 詳細ボタン |  | ボタン | | タスク詳細画面へ遷移 |

<br>

【タスク作成画面】
URL:
　/task/create

表示：

タスク作成
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タイトル | tasks.title | 文字列 | | 128文字まで |
| text | 1 | 内容 | tasks.content | 文字列 | | 1024文字まで |
| text | 1 | ラベル | labels.name | 文字列 | | 64文字まで 5件表示 |
| button | 1 | 作成ボタン |  | ボタン | | タスク作成 |
| button | 1 | 一覧へボタン |  | ボタン | | タスク一覧画面へ遷移 |

<br>

【タスク詳細画面】
URL:
　/task/details/{task.id}

表示：

タスク詳細
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| label | 1 | タイトル | tasks.title | 文字列 | | |
| label | 1 | 内容 | tasks.content | 文字列 | | |
| label | 1 | ラベル | labels.name | 文字列 | | 5件表示 |
| label | 1 | 状況 | tasks.status | 文字列 | | コードを文字列へ変換して表示 1:'未着手'、2:'着手中'、3:'完了' |
| button | 1 | 編集ボタン |  | ボタン | | タスク編集画面へ遷移 |
| button | 1 | 削除ボタン |  | ボタン | | タスク削除 |
| button | 1 | 一覧へボタン |  | ボタン | | タスク一覧画面へ遷移 |

<br>

【タスク編集画面】
URL:
　/task/edit/{task.id}

表示：

タスク編集
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タイトル | tasks.title | 文字列 | | 128文字まで |
| text | 1 | 内容 | tasks.content | 文字列 | | |
| text | 1 | ラベル | labels.name | 文字列 | | 64文字まで 5件表示 |
| button | 1 | ラベル追加ボタン |  | ボタン | | ラベル入力欄追加 |
| select | 1 | 状況 | TaskStatus(Enum) | 文字列 | | TaskStatus(Enum)の全てを表示※未着手、着手中、完了の順 |
| button | 1 | 更新ボタン |  | ボタン | | データを更新 |
| button | 1 | 詳細へボタン |  | ボタン | | タスク詳細画面へ遷移 |

<br>

* Script run

システム開始

``` shell
docker-compose exec api rails runner Maintenance::Functions::StartSystem.execute
```

システム停止

``` shell
docker-compose exec api rails runner Maintenance::Functions::StopSystem.execute
```

タスク作成機能開始

``` shell
docker-compose exec api rails runner Maintenance::Functions::StartCreate.execute
```

タスク作成機能停止

``` shell
docker-compose exec api rails runner Maintenance::Functions::StopCreate.execute
```

タスク更新機能開始

``` shell
docker-compose exec api rails runner Maintenance::Functions::StartUpdate.execute
```

タスク更新機能停止

``` shell
docker-compose exec api rails runner Maintenance::Functions::StopUpdate.execute
```

タスク削除機能開始

``` shell
docker-compose exec api rails runner Maintenance::Functions::StartDelete.execute
```

タスク削除機能停止

``` shell
docker-compose exec api rails runner Maintenance::Functions::StopDelete.execute
```

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
