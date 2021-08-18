# README
## Database Tables
### tasks テーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null: false,unique: true|
|user_id|references|null: false|
|title|string|null: false|
|content|text|null: false|
|status|string|enum(方法検討)|
|priority|string|enum(方法検討)|
|deadline|datetime||
|created|datetime||
|updated|datetime||
|deleted|boolean||

#### Association
- belongs_to :user
- has_many :labellings, dependent: :destroy
- has_many :labels, through: :labellings

### users テーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null: false,unique: true|
|name|string|null: false|
|created|datetime||
|updated|datetime||
|deleted|boolean||

#### Association
- has_many :tasks, dependent: :destroy

### labels テーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null: false,unique: true|
|user_id|references|null: false|
|name|string|null: false|
|created|datetime||
|updated|datetime||
|deleted|boolean||

#### Association
- belongs_to :user
- has_many :labellings, dependent: :destroy
- has_many :tasks, through: :labellings

### labellings テーブル
|Column|Type|Options|
|------|----|-------|
|id|integer|null: false,unique: true|
|label_id|references|null: false|
|task_id|references|null: false|
|created|datetime||
|updated|datetime||
|deleted|boolean||

#### Association
- belongs_to :task
- belongs_to :label


## 画面

TOPー新規ユーザ
 ＞ ユーザ登録

TOPーログイン
 ＞ タスク管理
 新規、一覧、検索、ソート、削除

 ＞ 登録/編集
タイトル、内容、優先順位、ステータス、期限、ラベル

 ＞ ラベル管理
 新規、一覧、削除
 ＞ 登録/編集




