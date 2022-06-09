## DB design (step5)

### users table
| Column | Type | Option |
| ------ | ---- | ------ |
| id | INT | PK |
| name | VARCHAR(64) | NOT NULL |
| email | VARCHAR(256) | NOT NULL |
| password | VARCHAR(256) | NOT MULL |
| is_admin | BOOLEAN | DEFAULT 0 |
| created_at | DATETIME | |
| updated_at | DATETIME | |

### tasks table
| Column | Type | Option |
| ------ | ---- | ------ |
| id | INT | PK |
| title | VARCHAR(64) | NOT NULL |
| description | VARCHAR(256) | |
| user_id | INT | FK |
| priority | INT | |
| status | INT | |
| expired_at | DATETIME | |
| created_at | DATETIME | |
| updated_at | DATETIME | |

### labels table
| Column | Type | Option |
| ------ | ---- | ------ |
| id | INT | PK |
| name | VARCHAR(64) | NOT NULL |
| created_at | DATETIME | |
| updated_at | DATETIME | |

### tasks_labels table
| Column | Type | Option |
| ------ | ---- | ------ |
| id | INT | PK |
| task_id  | INT | FK |
| label_id | INT | FK |
| created_at | DATETIME | |
| updated_at | DATETIME | |