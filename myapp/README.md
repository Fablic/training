# README

## DB テーブルスキーマ
### users
|  Field  |  Type  |  Null  |  Key  |  Default  |
| ---- | ---- | ---- | ---- | ---- |
| id | INT | NO | PRI |  |
|  name  |  VARCHAR(50)  |  NO  |    |    |
|  email  |  VARCHAR(256)  |  NO  |    |    |
|  password  |  VARCHAR(256)  |  NO  |    |    |
|  created_at  |  DATETIME  |  NO  |    |    |
|  updated_at  |  DATETIME  |  NO  |    |    |

### tasks
|  Field  |  Type  |  Null  |  Key  |  Default  |
| ---- | ---- | ---- | ---- | ---- |
| id | INT | NO | PRI |  |
| user_id | INT | NO |  |  |
|  title  |  VARCHAR(256)  |  NO  |    |    |
|  description  |  VARCHAR(256)  |  NO  |    |    |
|  termination_date  |  DATETIME  |  NO  |    |    |
|  priority  |  INT  |  NO  |    |    |
|  status  |  INT  |  NO  |    |    |
|  label_id  |  INT  |    |    |  -1 |
|  created_at  |  DATETIME  |  NO  |    |    |
|  updated_at  |  DATETIME  |  NO  |    |    |

### labels
|  Field  |  Type  |  Null  |  Key  |  Default  |
| ---- | ---- | ---- | ---- | ---- |
| id | INT | NO | PRI |  |
|  label  |  VARCHAR(256)  |  NO  |    |    |
|  color  |  INT  |  NO  |    |    |
|  created_at  |  DATETIME  |  NO  |    |    |
|  updated_at  |  DATETIME  |  NO  |    |    |