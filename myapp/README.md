# README

## 概要
[Rails研修のカリキュラム](https://github.com/Fablic/training/blob/develop/steps_jp.md#%E3%82%B9%E3%83%86%E3%83%83%E3%83%9717-%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3%E3%83%AD%E3%82%B0%E3%82%A2%E3%82%A6%E3%83%88%E6%A9%9F%E8%83%BD%E3%82%92%E5%AE%9F%E8%A3%85%E3%81%97%E3%82%88%E3%81%86)に沿って開発するTODOアプリです。

## 要件整理
### phase1 タスクの導入
- タスクの CRUD ができること
- 各タスクで以下のプロパティを持つこと
  - 名前
  - 詳細
  - 終了期限
  - ステータス(NEW,WIP,DONE)
  - 優先順位(low, middle, high)
- 以下でタスクの検索ができること
  - 名前
  - ステータス

### phase2 ユーザの導入
- ユーザの概念の導入
  - ログイン・ログアウト機能
  - 各タスクは1つのユーザに紐づく
  - 自分のタスクしか編集できない
- アドミンの導入
  - ユーザの CRUD 機能の実装

### phase3 ラベルの導入
- タスクにラベルをつけられるようにする
  - タスクには複数のラベルがつけられるようにする
  - タスクをラベルで検索できるようにする
- メンテナンスモードの導入

## ルーティング設計
### phase1 タスクの導入
- GET /
  - ユーザの概念導入前は /tasks にリダイレクトさせる
  - login 済みだったら /tasks にリダイレクト
  - login 済みでないなら /login にリダイレクト
- GET /tasks
- GET /tasks/new
- POST /tasks
- GET /tasks/:id
- GET /tasks/:id/edit
- POST /tasks/:id
- DELETE /tasks/:id

### [TBD] phase2 ユーザの導入
- GET /login
- POST /login
- DELETE /login
- GET /signup
- POST /users/new
- GET /admin/users
- GET /admin/users/new
- POST /admin/users
- GET /admin/users/:id
- GET /admin/users/:id/edit
- POST /admin/users/:id
- DELETE /admin/users/:id

### [TBD] phase3 ラベルの導入

## 画面設計
### phase1 タスクの導入
https://user-images.githubusercontent.com/37566073/219284406-606ed7b7-7f2a-46ee-991a-b164df4a755d.png

### [TBD] phase2 ユーザの導入
### [TBD] phase3 ラベルの導入

## テーブル設計
### phase1 タスクの導入

#### tasks table

column | type | null | default | key | unique | description
--- | --- | --- | ---  | ---  | ---  | ---
id | integer | false | - | - | true | rails が自動で作成するカラム。サロゲートキー。
name | string | false | - | - | - |
description | string | true | - | - | - |
deadline_at | datetime | true | - | - | - |
created_at | datetime | false | - | - | - | rails が自動で作成するカラム
updated_at | datetime | false | - | - | - | rails が自動で作成するカラム

### [TBD] phase2 ユーザの導入
### [TBD] phase3 ラベルの導入
