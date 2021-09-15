# ラクマTraining 

## ステップ6: タスクモデルを作成しましょう

タスクを管理するためのCRUDを作成します。
まずは名前と詳細だけが登録できるシンプルな構成で作りましょう。

- `rails generate` コマンドでタスクのCRUDに必要なモデルクラスを作成しましょう
- マイグレーションを作成し、これを用いてテーブルを作成しましょう
  - マイグレーションは1つ前の状態に戻せることを担保できていることが大切です！ `redo` を流して確認する癖をつけましょう
- `rails c` コマンドでモデル経由でデータベースに接続できることを確認しましょう
  - この時に試しにActiveRecordでレコードを作成してみましょう
- GitHub上でPRを作成してレビューしてもらいましょう
  - コメントがついたらその対応を行ってください。LGTM（Looks Good To Me）が2つついたら元のブランチにマージしましょう

## work log

### rails generate コマンドでタスクのCRUDに必要なモデルクラスを作成しましょう

`rails generate model task`を実行  
以下のファイルが生成された  
```txt
app/models/task.rb(model)
db/mygrate/xxx(日付+utc)_create_task.rb(migration時に作成されるfile?)
test/fixtures/tasks.yml(fixture)
test/models/tsk_test.rb
```
ひとまずこれで終わりかな...?

### マイグレーションを作成し、これを用いてテーブルを作成しましょう

さぁどのファイルを修正ればいいんだ？

db/schema.rbが必要なファイルを読み込んでtable作成してくれるぽい  
ここで疑問`ActiveRecord::Schema.define(version: 0) do` のActiveRecordとSchema.defineは何してるの？(学びにて記述)

結論スキーマ情報はdb/migrate/xxxxx_create_task.rbに記述
(schema.rbがdb/migrate/*を元に自動生成してくれる)  

#### myapp/db/migrate/20210909053717_create_tasks.rbの修正
早速xxxxx_create_task.rbにスキーマ情報を記述していく  
(今回は名前と詳細のみ！！！！！！！)

```rb
class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.timestamps
    end
  end
end
```

#### redoを流す

`rails db:migrate`: マイグレーションのバージョンを上げて、想定通り動く事を確認
`rails db:migrate:redo`: マイグレーションのバージョンを下げて、問題なく動く事を確認

### rils consoleを利用したDB接続確認

`rails c`でrailsのconlose機能を起動
ActiveRecordで
`root@6c00e9e1bc76:/myapp# rails c`
```rb
irb(main):001:0> Task.columns
=> [#<ActiveRecord::ConnectionAdapters::MySQL::Column:0x0000557316733258 @name="id", @sql_type_metadata=#<ActiveRecord::ConnectionAdapters::SqlTypeMetadata:0x0000557316733410 @sql_type="bigint(20)", @type=:integer, @limit=8, @precision=nil, @scale=nil>, @null=false, @default=nil, @default_function=nil, @collation=nil, @comment=nil>, #<ActiveRecord::ConnectionAdapters::MySQL::Column:0x0000557316731b38 @name="title", @sql_type_metadata=#<ActiveRecord::ConnectionAdapters::SqlTypeMetadata:0x0000557316731d18 @sql_type="varchar(255)", @type=:string, @limit=255, @precision=nil, @scale=nil>, @null=false, @default=nil, @default_function=nil, @collation="utf8mb4_general_ci", @comment=nil>, #<ActiveRecord::ConnectionAdapters::MySQL::Column:0x000055731675b5a0 @name="description", @sql_type_metadata=#<ActiveRecord::ConnectionAdapters::SqlTypeMetadata:0x000055731675b6e0 @sql_type="text", @type=:text, @limit=65535, @precision=nil, @scale=nil>, @null=false, @default=nil, @default_function=nil, @collation="utf8mb4_general_ci", @comment=nil>, #<ActiveRecord::ConnectionAdapters::MySQL::Column:0x0000557316759c28 @name="created_at", @sql_type_metadata=#<ActiveRecord::ConnectionAdapters::SqlTypeMetadata:0x0000557316759e30 @sql_type="datetime(6)", @type=:datetime, @limit=nil, @precision=6, @scale=nil>, @null=false, @default=nil, @default_function=nil, @collation=nil, @comment=nil>, #<ActiveRecord::ConnectionAdapters::MySQL::Column:0x0000557316759598 @name="updated_at", @sql_type_metadata=#<ActiveRecord::ConnectionAdapters::SqlTypeMetadata:0x0000557316759818 @sql_type="datetime(6)", @type=:datetime, @limit=nil, @precision=6, @scale=nil>, @null=false, @default=nil, @default_function=nil, @collation=nil, @comment=nil>]
```

#### AcriveRecordでレコード作成

testデータをcreate
```rb
irb(main):005:0> Task.create(title: 'task1', description: 'description1')
   (0.8ms)  BEGIN
  Task Create (0.8ms)  INSERT INTO `tasks` (`title`, `description`, `created_at`, `updated_at`) VALUES ('task1', 'description1', '2021-09-09 09:40:41.747217', '2021-09-09 09:40:41.747217')
   (2.4ms)  COMMIT
=> #<Task id: 1, title: "task1", description: "description1", created_at: "2021-09-09 09:40:41", updated_at: "2021-09-09 09:40:41">
```

createされたことをreadで確認
```rb
irb(main):006:0> Task.all
  Task Load (1.5ms)  SELECT `tasks`.* FROM `tasks` LIMIT 11
=> #<ActiveRecord::Relation [#<Task id: 1, title: "task1", description: "description1", created_at: "2021-09-09 09:40:41", updated_at: "2021-09-09 09:40:41">]>
```

## 学び

### rails generate
`rails generate xxx`をするだけで自動で追加される夢の世界  

### migration

そもそもmigrationとは  
[Railsがいどさん](https://railsguides.jp/active_record_migrations.html)によると
```txt
マイグレーションは、データベーススキーマの継続的な変更 (英語) を、統一的かつ簡単に行なうための便利な手法です。マイグレーションではRubyのDSLを使っているので、生のSQLを作成する必要がなく、スキーマとスキーマへの変更をデータベースの種類に依存せずに済みます。
```
要は生sql sqlを作成することなくスキーマ管理ができる便利ツールなイメージかな

### Active Record

#### 概要
[Railsガイドさん](https://railsguides.jp/active_record_basics.html)によると
```txt
ビジネスデータとビジネスロジックを表すシステムの階層
Active Recordは、データベースに恒久的に保存される必要のあるビジネスオブジェクトの作成と利用を円滑に行なえるようにします。Active Recordは、ORM (オブジェクト/リレーショナルマッピング) システムに記述されている「Active Recordパターン」を実装したものであり、このパターンと同じ名前が付けられています。
```
ORMの機能の一部で、ビジネスオブジェクト利用者にDBへの指示ができるような機能を提供してる感じかな

#### 今後必要そうな命名規則

| モデル/クラス | テーブル/スキーマ | ケース |
| --- | --- | --- |
| Task | tasks | 通常の複数形ケース |
| TaskLabel | task_labels | 複合語のケース |
| Person | Pepple | 単数と複数形が不規則な単語のケース |

#### スキーマのルール

外部キー: テーブル名の単数形_id (user_idなど)
`created_at`と`updated_at`は自動で設定される

### ActiveRecordeのSchema.define
参考: https://apidock.com/rails/ActiveRecord/Schema/define  
versionに合わせたtableを作成したり、更新したりする感じかな

### schema.rb
コメントアウトを見る限り、現状のtable情報をもとに自動で作成されるぽい
ここに定義されてる情報をもとに以下のコマンドの実行ができる
```txt
`db:schema:load`: define your schema 
`rails db:schema:load`: When creating a new database
```

### stringとtextの違い

| type | 説明 |
| --- | --- |
| string | 255、一言入力なイメージ|
| text | 無制限、長文向き|

### redoとは？
