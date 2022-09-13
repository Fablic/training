# README

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

参照： [日本語](../steps_jp.md)

# 完成イメージ

アプリケーション名:タスク管理アプリ
---
# View
* タスク一覧画面
<img width="1000" alt="Screen Shot 2022-09-13 at 11 16 59" src="https://user-images.githubusercontent.com/97163413/189792667-3d45a777-87c6-4b17-910f-d2df0ca05c22.png">

* タスク新規作成画面
* タスク編集画面
* タスク詳細画面
* ユーザ登録画面
* ユーザログイン画面

# モデル（テーブル）
## Tasks
column_name | type     | default
--          | --       | -- |
id          | int      | 
state       | int      |
priority    | int      |
label       | string   |
title       | string   |
description | string   |
created_by  | int      |
due_date    | datetime |

## Users
column_name        | type   | default
--                 | --     | -- |
id                 | int    | 
name               | string |
email              | string |
encrypted_password | string |
---

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
