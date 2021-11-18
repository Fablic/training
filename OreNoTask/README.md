# README

* Ruby version
2.5.7

## SET UP ENV

### 1.install ruby

```
rbenv install -v 3.0.2
rbenv global 3.0.2

brew install yarn
rails webpacker:install
```

### 2.install mysql
```
brew install mysql@8.0.26
```

### 3.create mysql user
```
mysql -uroot

create user 'ryo_ikebe'@'localhost' identified by 'ikeberyo';
grant all privileges on * . * to 'ryo_ikebe'@'localhost';
``` 

### 4.DB migration
```
rails db:migrate
```

### 5.rubocop
```
gem install rubocop
```

### 6.rspec
```
rails g rspec:install
```

### 7.to change maintenance mode
```
# メンテナンスモード開始
rails maint:start

# メンテナンスモード終了
rails maint:stop
```

## table list

### users
| column name    | type     | length | default | null     | key               | comment                 |
| :---           | :---     | ---:   | ---:    | ---:     | :---              | :---                    |
| id             | int      | 10     |       - | not null | primary; auto inc |                         |
| name           | vchr     | 20     |       - | not null | unique            |                         |
| password       | chr      | 128    |       - | not null |                   |                         |
| privilege      | int      | 1      |       0 | not null |                   | 0 = user, 1 = admin     |
| deleted        | int      | 1      |       0 | not null |                   | 0 = active, 1 = deleted |
| created_at     | datetime |      - |       - | not null |                   |                         |
| updated_at     | datetime |      - |    null | null     |                   |                         |

### labels
| column name   | type     | length | default | null     | key               | comment                 |
| :---          | :---     | ---:   | ---:    | ---:     | :---              | :---                    |
| id            | int      | 10     |       - | not null | primary; auto inc |                         |
| name          | vchr     | 20     |       - | not null | unique            |                         |
| color         | chr      | 6      |       - |     null |                   |                         |
| deleted       | int      | 1      |       0 | not null |                   | 0 = active, 1 = deleted |
| created_at    | datetime |      - |       - | not null |                   |                         |
| updated_at    | datetime |      - |    null | null     |                   |                         |

### tasks
| column name      | type     | length | default | null     | key               | comment                          |
| :---             | :---     | ---:   | ---:    | ---:     | :---              | :---                             |
| id               | int      | 10     |       - | not null | primary; auto inc |                                  |
| user_id          | int      | 10     |       - | not null |                   |                                  |
| name             | vchr     | 50     |       - | not null |                   |                                  |
| description      | text     | 2000   |       - |     null |                   |                                  |
| status           | int      | 1      |       0 | not null |                   | 0 = ready, 1 = wip, 2 = complete |
| start_at         | datetime |      - |       - | not null |                   |                                  |
| due_date_at      | datetime |      - |       - | not null |                   |                                  |
| deleted          | int      | 1      |       0 | not null |                   | 0 = active, 1 = deleted          |
| created_at       | datetime |      - |       - | not null |                   |                                  |
| updated_at       | datetime |      - |    null | null     |                   |                                  |

### task_labels
| column name   | type     | length | default | null     | key               | comment                 |
| :---          | :---     | ---:   | ---:    | ---:     | :---              | :---                    |
| id            | int      | 10     |       - | not null | primary; auto inc |                         |
| task_id       | int      | 10     |       - | not null |                   |                         |
| label_id      | int      | 10     |       - | not null |                   |                         |


