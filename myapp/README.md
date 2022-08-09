# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Database style

## tasks

|  COULMN  |  TYPE  |  KEY  |  NOT NULL  |  DEFAULT  |
| ---- | ---- | ---- | ---- | ---- |
|  id  |  INT(8)  |  Y  |  Y  |  auto_increment  |
|  title  |  VARCHAR(128)  |  N  |  Y  |  ''  |
|  description  |  TEXT  |  N  |  Y  |  -  |
|  user_id  |  INT(8)  |  N  |  Y  |  -  |
|  status  |  VARCHAR(1)  |  N  |  Y  |  '0'  |
|  label  |  VARCHAR(64)  |  N  |  N  |  -  |s
|  deleted_at  |  DATETIME  |  N  |  N  |  -  |
|  created_at  |  DATETIME  |  N  |  Y  |  -  |
|  updated_at  |  DATETIME  |  N  |  Y  |  -  |


status -> 0:未着手, 1:着手 , 2:完了

<br>

## users

|  COULMN  |  TYPE  |  KEY  |  NOT NULL  |  DEFAULT  |
| ---- | ---- | ---- | ---- | ---- |
|  id  |  INT(8)  |  Y  |  Y  |  auto_increment  |
|  name  |  VARCHAR(128)  |  N  |  Y  |  ''  |
|  deleted_at  |  DATETIME  |  N  |  N  |  -  |
|  created_at  |  DATETIME  |  N  |  Y  |  -  |
|  updated_at  |  DATETIME  |  N  |  Y  |  -  |
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
