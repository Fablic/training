# README


## Setup


1. Set up Ruby

```
rbenv install 3.0.1
rbenv global 3.0.1
```

2. Database Setup

```
cd docker
docker-compose up -d
```

MySQL8のバージョンで失敗する場合

- https://mebee.info/2020/07/25/post-15160/


3. Bundle install

```
bundle install
```

4. Setup webpacker

```
bundle exec rails webpacker:yarn_install
bundle exec rails assets:clobber
bundle exec rails webpacker:compile
```

5. Rails setup

```
bundle exec rails db:migrate
bundle exec rails db:seed
bundle exec rails server
```

5.1 Login App

```
### Admin
email: admin@example.com
password: AAAA1234

### Normal
email: normal@example.com
password: AAAA1234
```

6. Create test data

```
bundle exec rails c

> (1..10).each{|n| Task.create(title: Faker::Alphanumeric.alpha(number: 10), task_status: :todo, user_id: User.find_by({ username: 'admin' }).id) }
> (1..10).each{|n| Task.create(title: Faker::Alphanumeric.alpha(number: 10), task_status: :doing, user_id: User.find_by({ username: 'admin' }).id) }
> (1..10).each{|n| Task.create(title: Faker::Alphanumeric.alpha(number: 10), task_status: :done, user_id: User.find_by({ username: 'admin' }).id) }
```

## ペーパープロトタイピング

### 画面設計

![PXL_20210611_061009202](https://user-images.githubusercontent.com/85146460/121640279-af678880-cac8-11eb-95f5-55deba179cd2.jpg)
![PXL_20210611_061014064](https://user-images.githubusercontent.com/85146460/121640302-b393a600-cac8-11eb-9ee4-bc5a2666d626.jpg)

## モデル設計

![image](https://user-images.githubusercontent.com/85146460/121843649-a28fa280-cd1d-11eb-95d9-eaea1972f9b9.png)

### tasks タスク

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  name  |  varchar(255)  | not null  | タスク名, 検索対象 |
|  description  |  text  | null | タスク説明 |
|  task_status  |  enum(todo, doing, done)  | todo | タスクステータス |
|  task_level  |  enum(high, middle, low)  | middle | 優先度 |
|  task_label_id  |  integer | null  | ラベルリレーションカラム, FK |
|  user_id  |  uuid | not null  | ユーザリレーションカラム, FK |
|  end_at  |  datetime  | null  | 終了期限 |
|  created_at  |  datetime | default now() | 作成日時 |
|  updated_at  |  datetime | default updated now() | 更新日時 |

### task_labels タスクラベル（多対多リレーション）

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  task_id  |  integer  | not null | タスクリレーションカラム |
|  label_id  |  integer  | not null | ラベルリレーションカラム |
|  created_at  |  datetime | default now() | 作成日時 |
|  updated_at  |  datetime | default updated now() | 更新日時 |

> unique制約 taskId, labelId

### labels ラベル

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  integer  | auto_increment | プライマリーキー |
|  name  |  varchar(50)  | not null | ラベル名 |
|  color  |  enum(red, yellow, green,...)  | null | カラー |
|  created_at  |  datetime | default now() | 作成日時 |
|  updated_at  |  datetime | default updated now() | 更新日時 |

> unique制約 name

### users ユーザ

|  Column  |  Type  | Default  |  Description  |
| ---- | ---- | ---- | ---- |
|  id  |  uuid  | auto_increment | プライマリーキー |
|  username  |  varchar(20)  | not null | ユーザ名 |
|  icon  |  varchar(255)  | null | アイコン画像URL |
|  role  |  enum(normal, maintainer)  | default normal | 権限 |
|  email  |  varchar(255)  | not null | メールアドレス |
|  password_digest  |  varchar(255)  | not null | パスワード |
|  created_at  |  datetime | default now() | 作成日時 |
|  updated_at  |  datetime | default updated now() | 更新日時 |

> unique制約 username
