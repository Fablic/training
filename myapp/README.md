# システムの要件
本カリキュラムでは、課題としてタスク管理システムを開発していただきます。 タスク管理システムでは、以下のことを行いたいと考えています。

- 自分のタスクを簡単に登録したい
- タスクに終了期限を設定できるようにしたい
- タスクに優先順位をつけたい
- ステータス（未着手・着手・完了）を管理したい
- ステータスでタスクを絞り込みたい
- タスク名・タスクの説明文でタスクを検索したい
- タスクを一覧したい。一覧画面で（優先順位、終了期限などを元にして）ソートしたい
- タスクにラベルなどをつけて分類したい
- ユーザ登録し、自分が登録したタスクだけを見られるようにしたい
- メンテナンスを実施できるようにしたい
- ユーザの管理機能

参照： [training日本語](../steps_jp.md)

# 完成イメージ

## アプリケーション名
タスク管理アプリ

## ビュー
* タスク一覧画面
<img width="1000" alt="Screen Shot 2022-09-13 at 11 16 59" src="https://user-images.githubusercontent.com/97163413/189797985-b99c6984-df49-422d-89b4-7b36ce3a63bf.png">

* タスク新規作成画面
* タスク編集画面
* タスク詳細画面
* ユーザ登録画面
* ユーザログイン画面

## モデル（テーブル）
### Tasks
column_name | type    |
--          | --      |
id          | integer | 
status      | integer |
priority    | integer | 
label       | string  |
title       | string  |
description | text    |
created_by  | integer |
due_date    | datetime|

※ statusについて 1:未着手、2:着手中、3:完了

※ priorityについて 1:低、2:中、3:高

※ created_by:N　→ users.id:1

### Users
column_name     | type    |
--              | --      |
id              | integer |
name            | string  |
email           | string  |
password_digest | string  |

※ id:1　→ tasks.created_by:N
