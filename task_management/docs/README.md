# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  
  2.6.6
  

* System dependencies


* Configuration


* Database creation


* Database initialization


* How to run the test suite


* Services (job queues, cache servers, search engines, etc.)


* Deployment instructions


* Premise
  
  タスクの優先順位（低・中・高）、
  及びステータス（未着手・着手・完了）の増減は無いものとする


* Screen design
  
  1.タスク管理画面
    https://gomockingbird.com/projects/ng0fv2h/4gXVnC

  2.ユーザ登録画面
    https://gomockingbird.com/projects/ng0fv2h/TnMd3U

  3.ログイン画面
    https://gomockingbird.com/projects/ng0fv2h/PduyV7

  4.メンテナンス画面
    https://gomockingbird.com/projects/ng0fv2h/6cwKfd


* Table schema

  1.タスク管理テーブル

    ・タスクID PK INT
  
    ・ユーザID INT

    ・タスク名 VARCHAR

    ・タスク詳細 VARCHAR

    ・終了期限 DATETIME

    ・ステータス CHAR (0:未着手・1:着手・2:完了)
  
    ・優先順位 CHAR（0:低・1:中・2:高）
  
    ・作成日時 DATETIME
  
  2.タスク管理テーブル-ラベルマスタ紐付テーブル

    ・タスクID UK INT

    ・ラベルマスタID UK INT

  3.ラベルマスタ

    ・ラベルマスタID PK INT

    ・ラベル名 UK VARCHAR
  
  4.ユーザテーブル

    ・ユーザID PK INT

    ・パスワード(暗号化して登録) VARCHAR

    ・権限ID INT
  
  5.ユーザ権限マスタ

    ・ユーザ権限マスタID PK INT

    ・権限名 VARCHAR