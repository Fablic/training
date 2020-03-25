## Trainingは以下のページを参考に行っております。
https://github.com/Fablic/training/tree/use_docker

## TreasureMap

### What is it?
- This is TreasureMap, it is Task Management System

### Why
- Project success is like that found Treasure, so Task Management System is like to Treasure map for that found Tresure
- Explorer who using service users is make Treasure map via task as done
- Finally, explorer is found tresure.

### Technical Environment
* Ruby version
2.6.5

* Rails version
6.0.2.1

* Database
Mysql2
5.7.29

## アプリを起動する方法
1.dockerを利用しているdockerをbuildします。
```
docker-compose up --build
```
2.buildが終わったら、localhost:3001/projectsで接続を確認してください。projectの一覧画面が出ると成功

3.cssとjavascriptを反映する
```
docker-compose exec api rake assets:precompile
```

## build中のエラー対応
1.Webpacker::Manifest::MissingEntryErrorが出た場合に以下のコマンドを実行し、改めてdocker-compose up --buildを行なってください。

```
yarn
```

2.Your Yarn packages are out of date! Please run 'yarn install --check-files' to update.'が出た場合にyarn.lock fileを削除し、改めてdocker-compose up --buildを行なってください。

```
rm -rf yarn.lock
```

## サーバを起動した後のエラー対応
1.Run `npm rebuild node-sass`が出た場合には以下のコマンを実行すればいいです。解決

```
npm rebuild node-sass
```

## Maintenance
 To start maintenance input the rake command below
 > bundle exec rake maintenance:start

 To end maintenance input the rake command below
 > bundle exec rake maintenance:end

## アプリケーションスケッチ(基本、Trelloをベンチマーキング)
- プロフェクトの一覧ページ
![Project index](https://user-images.githubusercontent.com/18366817/74903204-a5a9a580-53eb-11ea-9c71-341ba39146d0.jpg)

- タスク一覧ページ
![Indexpage](https://user-images.githubusercontent.com/18366817/74700095-ee275e80-5245-11ea-8db0-4a3854fe0393.jpg)

- タスク詳細管理ページ
![showDetailTask](https://user-images.githubusercontent.com/18366817/74700124-07300f80-5246-11ea-86fa-7903b050d241.jpg)

- ログインページ
![loginpage](https://user-images.githubusercontent.com/18366817/74700155-14e59500-5246-11ea-8355-119743c6c9a3.jpg)

- ユーザー登録ページ
![Registeruser](https://user-images.githubusercontent.com/18366817/74700174-2038c080-5246-11ea-8a9a-87abcfae025d.jpg)

## DB設計

- UML DB
![UMLDB](https://user-images.githubusercontent.com/18366817/75217971-082fe680-57dc-11ea-8d04-0241e5618aba.jpg)

- 補足
Applicationの構成図に伴い、TrainingにはないProjectとGroupsがあります。
ユーザーはProjectを作成し、そのProjectのstatusをGroupsで管理ますね。
そして、TaskはGroupの中に所属しておりました。taskのstatusが変更する際に所属しているGroupsが変更されます。

TrainingにはあるStatusというものを代わりにGroupsという名前した理由は
Statusの汎用性を上げるために名前を変更しました。

- DB詳細情報
```
DROP TABLE IF EXISTS TASK_LABELS;
DROP TABLE IF EXISTS TASKS;
DROP TABLE IF EXISTS LABELS;
DROP TABLE IF EXISTS GROUPS;
DROP TABLE IF EXISTS USER_PROJECTS;
DROP TABLE IF EXISTS USER_LOGIN_MANAGERS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS PROJECTS;

-- create users table
CREATE TABLE USERS(
  id INT NOT NULL AUTO_INCREMENT,
  nickname VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_digest VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  UNIQUE(email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create user_login_managers table
CREATE TABLE USER_LOGIN_MANAGERS(
  id INT NOT NULL AUTO_INCREMENT,
  remember_token VARCHAR(255) NOT NULL,
  browser VARCHAR(255) NOT NULL,
  ip VARCHAR(255) NOT NULL,
  user_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id)
  FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create projects table
CREATE TABLE PROJECTS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX projects_name_idx ON PROJECTS (name);

-- create user_projects table, this table is middle table
CREATE TABLE USER_PROJECTS(
  id INT NOT NULL AUTO_INCREMENT,
  user_id INT NOT NULL,
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id)
  FOREIGN KEY (project_id) REFERENCES PROJECTS(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create GROUPS table
CREATE TABLE GROUPS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  sort_number INT NOT NULL, -- 画面でGROUPSの表示順番を決める
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (project_id) REFERENCES PROJECTS (id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create labels table
CREATE TABLE LABELS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  color: VARCHAR(255) NOT NULL DEFAULT '#B4BAC4',
  project_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (project_id) REFERENCES PROJECTS (id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create tasks table
CREATE TABLE TASKS(
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  priority INT NOT NULL, -- Maganement as ENUM(HIGH: 1, MIDDLE: 2, LOW: 3)
  end_period_at DATE NULL,
  group_id INT NOT NULL,
  creator_name VARCHAR(255) NULL,
  creator_user_id int NULL,
  assignee_name VARCHAR(255) NULL,
  assignee_user_id int NULL,
  label_id INT NULL,
  description TEXT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (group_id) REFERENCES GROUPS (id) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (label_id) REFERENCES LABELS (id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- create task_labels table, this table is middle table
CREATE TABLE TASK_LABELS(
  id INT NOT NULL AUTO_INCREMENT,
  task_id INT NOT NULL,
  label_id INT NOT NULL,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  PRIMARY KEY (id),
  UNIQUE(id),
  FOREIGN KEY (task_id) REFERENCES TASKS(id) ON DELETE CASCADE,
  FOREIGN KEY (label_id) REFERENCES LABELS(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


```
