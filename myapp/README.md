## 対象課題
https://github.com/Fablic/training/tree/stakahashi-d/myapp/docs

## テーブルスキーマ(仮)
### users

|  カラム名  |  タイプ  |
| ---- | ---- |
|  id  |  int  |
|  name  |  string  |
|  password  |  string  |
|  email  |  string  |
|  admin_flg | int |

### tasks

|  カラム名  |  タイプ  |
| ---- | ---- |
|  id  |  int  |
|  user_id  |  int  |
|  name  |  string  |
|  description  |  string  |
|  status_id  |  int  |
|  priority_id  |  int  |
|  due_date  |  datetime  |
|  created_at | datetime |
|  updated_at | datetime |

### task_labels

|  カラム名  |  タイプ  |
| ---- | ---- |
|  id  |  int  |
|  task_id | int |
|  label_id | int |

### labels

|  カラム名  |  タイプ  |
| ---- | ---- |
|  id  |  int  |
|  name  |  string  |

### status

|  カラム名  |  タイプ  |
| ---- | ---- |
|  id  |  int  |
|  name  |  string  |

### priorities

|  カラム名  |  タイプ  |
| ---- | ---- |
|  id  |  int  |
|  name  |  string  |

## システムの利用

* ブラウザで下記のURLにアクセスしてください
  * http://localhost:3001/
