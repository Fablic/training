# テーブル構成
## users テーブル
|Column|Type|Options|
|------|----|-------|
|user_id|INT AUTO_INCREMENET|PK,index,NOTNULL|
|name|VARCHAR(256)|NOT NULL|
|mail_address|VARCHAR(128)||
|role_id|TINYINT|DEFAULT 0|
|lastest_login_date|DATETIME||
|regist_date|DATETIME|NOTNULL|
|update_date|DATETIME||
|regist_user|DATETIME|NOTNULL|
|update_user|DATETIME||
|del_flag|boolean|default false|



## tasksテーブル
|Column|Type|Options|
|------|----|-------|
|task_id|INT AUTO_INCREMENT|PK,index,NOTNULL|
|user_id|INT|NOTNULL|
|status|TINYINT|NOTNULL,default 0|
|period_date|DATETIME||
|priority|INT|default 0|
|description|VARCHAR(1024)||
|label_id_1|INT||
|label_id_2|INT||
|label_id_3|INT||
|label_id_4|INT||
|label_id_5|INT||
|regist_date|DATETIME|NOTNULL|
|update_date|DATETIME||
|regist_user|DATETIME|NOTNULL|
|update_user|DATETIME||
|del_flag|boolean|default false|


## labelsテーブル
|Column|Type|Options|
|------|----|-------|
|label_id|INT AUTO_INCREMENT|PK,index,NOTNULL|
|label_name|VARCHAR(256)||
|user_id|INT|NOTNULL|


