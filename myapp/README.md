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
| deleted_at | datetime | | |
| created_at | datetime | | |
| updated_at | datetime | | |

※statusについて
1:未着手、2:着手中、3:完了
※結合キー
user_id:N　→ users.id:1
id:1　→ task_labels.task_id:N
<br>

labels
| column_name | type | null | default |
| ---- | ---- | ---- | ---- |
| id | integer(20) | not null | auto_increment |
| name | varchar(64) | not null | '' |
| deleted_at | datetime | | |
| created_at | datetime | | |
| updated_at | datetime | | |

※結合キー
id:1　→ task_labels.label_id:N
<br>

task_labels
| column_name | type | null | default |
| ---- | ---- | ---- | ---- |
| id | integer(20) | not null | auto_increment |
| task_id | integer(20) | not null | auto_increment |
| label_id | integer(20) | not null | auto_increment |
| deleted_at | datetime | | |
| created_at | datetime | | |
| updated_at | datetime | | |
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

ラベル管理エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| button　| 1 | ラベル管理ボタン |  | ボタン | | ラベル一覧画面へ遷移 |

<br>

タスク作成エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| button　| 1 | 作成ボタン |  | ボタン | | タスク作成画面へ遷移 |

<br>

検索エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | タイトル検索フォーム | title | 文字列 | | 部分一致、128文字まで |
| select | 1 | 状況 | status | 文字列 |  | ステータス |
| select | 1 | ラベル | label | 文字列 |  | ラベル |
| button　| 1 | 検索ボタン |  | ボタン | | タスク一覧を条件に応じて絞り込み |

<br>

タスク一覧エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| - | 1 | タスク | tasks + users | オブジェクト | ○ | tasksとusersを結合したオブジェクトリスト、作成日順 |
| label | 1 | タイトル | tasks.title | 文字列 | | |
| label | 1 | ラベル | labels.name | 文字列 | | 複数表示 |
| label | 1 | 状況 | tasks.status | 文字列 | | コードを文字列へ変換して表示 1:'未着手'、2:'着手中'、3:'完了' |
| button | 1 | 詳細ボタン |  | ボタン | | タスク詳細画面へ遷移 |

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
| select | 1 | ラベル | labels.name | 文字列 | | 64文字まで 5件表示 |
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
docker-compose exec api rake 'function:start[9]'
```

システム停止

``` shell
docker-compose exec api rake 'function:stop[9]'
```

タスク作成機能開始

``` shell
docker-compose exec api rake 'function:start[1]'
```

タスク作成機能停止

``` shell
docker-compose exec api rake 'function:stop[1]'
```

タスク更新機能開始

``` shell
docker-compose exec api rake 'function:start[2]'
```

タスク更新機能停止

``` shell
docker-compose exec api rake 'function:stop[2]'
```

タスク削除機能開始

``` shell
docker-compose exec api rake 'function:start[3]'
```

タスク削除機能停止

``` shell
docker-compose exec api rake 'function:stop[3]'
```

【ラベル一覧画面】
URL:
　/labels

表示：

ラベル一覧エリア
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| label | 1 | ラベル名 | labels.name | 文字列 | | |
| button | 1 | 詳細ボタン |  | ボタン | | タスク詳細画面へ遷移 |

<br>

【ラベル作成画面】
URL:
　/label/create

表示：

ラベル作成
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | ラベル名 | labels.name | 文字列 | | 64文字まで |
| button | 1 | 作成ボタン |  | ボタン | | ラベル作成 |
| button | 1 | 一覧へボタン |  | ボタン | | ラベル一覧画面へ遷移 |

<br>

【ラベル詳細画面】
URL:
　/label/details/{label.id}

表示：

ラベル詳細
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| label | 1 | ラベル名 | labels.name | 文字列 | | |
| label | 1 | 作成日 | labels.created_at | 文字列 | | |
| label | 1 | 更新日 | labels.updated_at | 文字列 | | |
| button | 1 | 編集ボタン |  | ボタン | | ラベル編集画面へ遷移 |
| button | 1 | 削除ボタン |  | ボタン | | ラベル削除 |
| button | 1 | 一覧へボタン |  | ボタン | | ラベル一覧画面へ遷移 |

<br>

【ラベル編集画面】
URL:
　/label/edit/{label.id}

表示：

ラベル編集
| item | layer | name | source | type | loop | others |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| text | 1 | ラベル名 | labels.name | 文字列 | | 64文字まで |
| button | 1 | 更新ボタン |  | ボタン | | データを更新 |
| button | 1 | 一覧へボタン |  | ボタン | | ラベル一覧画面へ遷移 |

<br>


* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
