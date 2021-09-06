# README

* Ruby version
2.5.7

## table list

### users
| column name    | type     | length | default | null     | key               | comment                 |
| :---           | :---     | ---:   | ---:    | ---:     | :---              | :---                    |
| id             | int      | 10     |       - | not null | primary; auto inc |                         |
| user_name      | vchr     | 20     |       - | not null | unique            |                         |
| user_password  | chr      | 128    |       - | not null |                   |                         |
| user_privilege | int      | 1      |       0 | not null |                   | 0 = user, 1 = admin     |
| deleted        | int      | 1      |       0 | not null |                   | 0 = active, 1 = deleted |
| created        | datetime |      - |       - | not null |                   |                         |
| modified       | datetime |      - |    null | null     |                   |                         |

### labels
| column name   | type     | length | default | null     | key               | comment                 |
| :---          | :---     | ---:   | ---:    | ---:     | :---              | :---                    |
| id            | int      | 10     |       - | not null | primary; auto inc |                         |
| label_name    | vchr     | 20     |       - | not null | unique            |                         |
| label_color   | chr      | 6      |       - |     null |                   |                         |
| deleted       | int      | 1      |       0 | not null |                   | 0 = active, 1 = deleted |
| created       | datetime |      - |       - | not null |                   |                         |
| modified      | datetime |      - |    null | null     |                   |                         |

### tasks
| column name      | type     | length | default | null     | key               | comment                          |
| :---             | :---     | ---:   | ---:    | ---:     | :---              | :---                             |
| id               | int      | 10     |       - | not null | primary; auto inc |                                  |
| user_id          | int      | 10     |       - | not null |                   |                                  |
| task_name        | vchr     | 50     |       - | not null |                   |                                  |
| task_description | text     | 2000   |       - |     null |                   |                                  |
| status           | int      | 1      |       0 | not null |                   | 0 = ready, 1 = wip, 2 = complete |
| due_date         | datetime |      - |       - | not null |                   |                                  |
| deleted          | int      | 1      |       0 | not null |                   | 0 = active, 1 = deleted          |
| created          | datetime |      - |       - | not null |                   |                                  |
| modified         | datetime |      - |    null | null     |                   |                                  |

### task_labels
| column name   | type     | length | default | null     | key               | comment                 |
| :---          | :---     | ---:   | ---:    | ---:     | :---              | :---                    |
| id            | int      | 10     |       - | not null | primary; auto inc |                         |
| task_id       | int      | 10     |       - | not null |                   |                         |
| label_id      | int      | 10     |       - | not null |                   |                         |


