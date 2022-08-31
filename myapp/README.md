# README

アプリケーション名:タスク管理アプリ

---

画面
* 一覧画面
* 新規作成画面
* 編集画面
* 詳細画面
* ユーザ登録画面
* ログイン画面
* 検索画面

DB

* Task

column_name | type   | default
--          | --     | -- |
id          | int    | 
state       | string |
priority    | string |
label       | string |
title       | string |
description | string |
createdby   | int    |
limit_date  | date   |

* User

column_name | type   | default
--          | --     | -- |
id          | int    | 
name        | string |
email       | string |
password    | string |

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
