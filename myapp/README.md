# テーブル構成
2021.10.04.更新

## users テーブル
|Column|Type|Options|
|------|----|-------|
|user_id|INT AUTO_INCREMENET|PK,index,NOTNULL|
|name|VARCHAR(256)|NOT NULL|
|mail_address|VARCHAR(128)||
|role_id|TINYINT|DEFAULT 0|
|latest_login_date|DATETIME||
|regist_user_id|integer|NOTNULL|
|created_at|DATETIME||
|updated_at|DATETIME||
|update_user_id|integer||
|del_flag|boolean|default false|

 ### relation:
- regist_user_id -> users.user_id
- update_user_id -> users.user_id


## tasksテーブル
2021.10.04.更新 status

|Column|Type|Options|
|------|----|-------|
|task_id|INT AUTO_INCREMENT|PK,index,NOTNULL|
|name|VARCHAR(256)||
|description|VARCHAR(1024)||
|due_date|DATETIME||
|user_id|INT|タスクの担当者 userとrelation持たせた後にNOTNULLにする|
|status|enum('new','progress','complete')|NOTNULL,default 'new'|
|created_at|DATETIME||
|updated_at|DATETIME||

### 以下は追加検討中（現時点では未実装のカラム）
|Column|Type|Options|
|------|----|-------|
|priority|INT|default 0|
|label_id_1|INT||
|label_id_2|INT||
|label_id_3|INT||
|label_id_4|INT||
|label_id_5|INT||
|regist_user_id|integer|NOTNULL,タスクを登録した人（担当者と違う場合がある）|
|update_user_id|integer||
|del_flag|boolean|default false|

 ### relation:
- user_id -> users.user_id
- regist_user_id -> users.user_id
- update_user_id -> users.user_id
- label_id_1~5 -> labels.label_id

### その他
- ラベル:
ひとつのタスクに対してたくさんは要らないという想定で５個決めうちにしている。
後々relationテーブルを作って個数制限を外す（labelカラムを廃止）するかもしれない。



## labelsテーブル
|Column|Type|Options|
|------|----|-------|
|id|INT AUTO_INCREMENT|PK,index,NOTNULL|
|label_name|VARCHAR(256)||
|user_id|INT|NOTNULL|
|created_at|DATETIME||
|updated_at|DATETIME||

 ### relation:
- user_id -> users.user_id

