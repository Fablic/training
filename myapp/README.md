## 対象課題
https://github.com/Fablic/training/tree/stakahashi-d/myapp/docs

## テーブルスキーマ
### Users

|  カラム名  |  タイプ  |
| ---- | ---- |
|  id  |  int  |
|  name  |  string  |
|  password  |  string  |
|  email  |  string  |

### Tasks

|  カラム名  |  タイプ  |
| ---- | ---- |
|  id  |  int  |
|  user_id  |  int  |
|  name  |  string  |
|  content  |  string  |
|  status  |  int  |
|  label  |  int  |
|  priority  |  int  |
|  end_date  |  datetime  |

## システムの利用

* ブラウザで下記のURLにアクセスしてください
  * http://localhost:3001/
