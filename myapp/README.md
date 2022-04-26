# README

## DB テーブルスキーマ
### users
|  Field  |  Type  |  Null  |  Key  |  Default  |
| ---- | ---- | ---- | ---- | ---- |
| id | INT | NO | PRI |  |
|  name  |  VARCHAR(50)  |  NO  |    |    |
|  email  |  VARCHAR(256)  |  NO  |    |    |
|  encrypted_password  |  VARCHAR(256)  |  NO  |    |    |
|  created_at  |  DATETIME  |  NO  |    |    |
|  updated_at  |  DATETIME  |  NO  |    |    |

### tasks
|  Field  |  Type  |  Null  |  Key  |  Default  |
| ---- | ---- | ---- | ---- | ---- |
| id | INT | NO | PRI |  |
| user_id | INT | NO | FK |  |
|  title  |  VARCHAR(256)  |  NO  |    |    |
|  description  |  VARCHAR(256)  |  NO  |    |    |
|  termination_at  |  DATETIME  |  NO  |    |    |
|  priority  |  TINYINT(4)  |  NO  |    |    |
|  status  |  TINYINT(4)  |  NO  |    |    |
|  created_at  |  DATETIME  |  NO  |    |    |
|  updated_at  |  DATETIME  |  NO  |    |    |

### labels
|  Field  |  Type  |  Null  |  Key  |  Default  |
| ---- | ---- | ---- | ---- | ---- |
| id | INT | NO | PRI |  |
|  name  |  VARCHAR(256)  |  NO  |    |    |
|  color  |  TINYINT(4)  |  NO  |    |    |
|  created_at  |  DATETIME  |  NO  |    |    |
|  updated_at  |  DATETIME  |  NO  |    |    |

### tasks_labels
|  Field  |  Type  |  Null  |  Key  |  Default  |
| ---- | ---- | ---- | ---- | ---- |
| id | INT | NO | PRI |  |
| task_id | INT | NO | FK |  |
|  label_id  |  INT |  NO  |  FK  |    |
|  created_at  |  DATETIME  |  NO  |    |    |
|  updated_at  |  DATETIME  |  NO  |    |    |