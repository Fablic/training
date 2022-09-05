# README

## アプリケーション名
タスク管理アプリ

---

## 画面
* タスク一覧画面
* タスク新規作成画面
* タスク編集画面
* タスク詳細画面
* ユーザ登録画面
* ログイン画面
* 検索画面

## DB
### Task
column_name | type    |
--          | --      |
id          | integer | 
state       | integer |
priority    | integer | 
label       | varchar |
title       | varchar |
description | varchar |
created_by  | integer |
limit_date  | datetime|

### User
column_name | type    |
--          | --      |
id          | integer |
name        | varchar |
email       | varchar |
password    | varchar |

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
