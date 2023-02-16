# README

## 概要
TODOアプリです。

## 要件整理
### phase1 タスクの導入
- タスクの CRUD ができること
- 各タスクで以下のプロパティを持つこと
  - 名前
  - 終了期限
  - ステータス(未着手,着手中,完了)
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


### [TBD] phase2 ユーザの導入
### [TBD] phase3 ラベルの導入
