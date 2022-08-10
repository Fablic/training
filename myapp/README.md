# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Database style

## Task

|  カラム名  |  型  |  キー  |  not null  |  default  |
| ---- | ---- | ---- | ---- | ---- |
|  id  |  INT(8)  |  ●  |  yes  |  auto_increment  |
|  title  |  VARCHAR(128)  |    |  yes  |  ''  |
|  description  |  TEXT  |    |  no  |  -  |
|  user_id  |  INT(8)  |    |  yes  |  -  |
|  status  |  VARCHAR(1)  |    |  yes  |  '0'  |
|  label  |  VARCHAR(64)  |    |  no  |  -  |
|  deleted_at  |  DATETIME  |    |  no  |  -  |
|  created_at  |  DATETIME  |    |  yes  |  -  |
|  updated_at  |  DATETIME  |    |  yes  |  -  |
<br>

## User

|  カラム名  |  型  |  キー  |  not null  |  default  |
| ---- | ---- | ---- | ---- | ---- |
|  id  |  INT(8)  |  ●  |  yes  |  auto_increment  |
|  name  |  VARCHAR(128)  |    |  yes  |  ''  |
|  deleted_at  |  DATETIME  |    |  no  |  -  |
|  created_at  |  DATETIME  |    |  yes  |  -  |
|  updated_at  |  DATETIME  |    |  yes  |  -  |
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
