# README

* Ruby version
2.5.7

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


