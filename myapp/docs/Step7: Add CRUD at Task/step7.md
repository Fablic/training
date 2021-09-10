# Rakuma training

## ステップ7: タスクを登録・更新・削除できるようにしよう

- タスクの一覧画面、作成画面、詳細画面、編集画面を作成しましょう
  - `rails generate` コマンドでコントローラとビューを作成します
  - コントローラとビューに必要な実装を追加しましょう
  - 作成、更新、削除後はそれぞれflashメッセージを画面に表示させましょう
- `routes.rb` を編集して、 `http://localhost:3000/` でタスクの一覧画面が表示されるようにしましょう
- `Gemfile` で [RuboCop](https://github.com/rubocop/rubocop)（Rubyの静的コード解析ツール） か [fablicop](https://github.com/Fablic/fablicop)をインストールしましょう。設定やコマンド実行方法は各READMEから確認しましょう。
- GitHub上でPRを作成してレビューしてもらいましょう
  - 今後、PRが大きくなりそうだったらPRを2回以上に分けることを検討しましょう

## work log

### タスクの一覧画面、作成画面、詳細画面、編集画面を作成しましょう

`rails g controller Tasks edit create list detail`で作成

```sh
root@6c00e9e1bc76:/myapp# rails g controller Tasks edit create list detail
Running via Spring preloader in process 728
      create  app/controllers/tasks_controller.rb
       route  get 'tasks/edit'
get 'tasks/create'
get 'tasks/list'
get 'tasks/detail'
      invoke  erb
      create    app/views/tasks
      create    app/views/tasks/edit.html.erb
      create    app/views/tasks/create.html.erb
      create    app/views/tasks/list.html.erb
      create    app/views/tasks/detail.html.erb
      invoke  test_unit
      create    test/controllers/tasks_controller_test.rb
      invoke  helper
      create    app/helpers/tasks_helper.rb
      invoke    test_unit
      invoke  assets
      invoke    scss
      create      app/assets/stylesheets/tasks.scss
```




### `routes.rb` を編集して、 `http://localhost:3000/` でタスクの一覧画面が表示されるようにしましょう

### `Gemfile` で [RuboCop](https://github.com/rubocop/rubocop)（Rubyの静的コード解析ツール） か [fablicop](https://github.com/Fablic/fablicop)をインストールしましょう。

## 学び

### rails g controller

基本形(オプションなし)
`rails generate controller {controller name}`

アクションとビューも作成(アクションは複数指定可能)
`rails generate controller {controller name} [{action name}...]`

### viewの記述
htmlの記述が現状だと面倒だったのでvscodeにてerbファイルでemmetを使えるように設定を追加

#### 設定変更
Emmet: Trigger Expansion On Tab をONにする

#### emmitの拡張設定
settings.jsonに記述追加
```json
// emmitの拡張設定
    "emmet.includeLanguages": {
        "erb": "html"
    }
```

### link_to
リンクを作成するHelper関数
[参考ページ](https://railsdoc.com/page/link_to)

#### rake routesで各アクションへのパスを確認
`rails routes`

```sh
Prefix    Verb   URI Pattern                   Controller#Action
root      GET    /                             tasks#index
tasks     GET    /tasks(.:format)              tasks#index
          POST   /tasks(.:format)              tasks#create
new_task  GET    /tasks/new(.:format)          tasks#new
edit_task GET    /tasks/:id/edit(.:format)     tasks#edit
task      GET    /tasks/:id(.:format)          tasks#show
          PATCH  /tasks/:id(.:format)          tasks#update
          PUT    /tasks/:id(.:format)          tasks#update
          DELETE /tasks/:id(.:format)          tasks#destroy
```

なので、showページに飛ばしたいときは
`link_to 'hogehoge', task`となる(getはhttp methodのdefaultのためmethod引数に値をセットする必要がない)  
このとき、show actionに対応する prefix, verb, URI Patternは以下  
`task GET /tasks/:id(.:format)  tasks#show`  
そのためリンクには自動的にtask.idがgetパラメータとして与えられた状態になる(むしろtask(id: task.id)とすると引数的にエラーになる)  

同様にdelete, patch, put. getをする際もtaskを利用する
`link_to 'Delete', task, method: :delete, data: { confirm: 'Are you sure?' }`

### `@instance = Model.find(params[:id])`について

そもそも`@hogehoge`は**インスタンス変数**


### シンボル
「:」はシンボルで、文字列にコロン記号を前置して定義したもの  
「""」の代わりに利用されて、
後置として利用した場合は、ハッシュのキーや、キーワード引数として扱われる

#### 文字列とシンボルの違い

シンボルがポインタとなり、複数回使用しても同じ領域を利用する
例)  
文字列の場合
```rb
str1 = "rakuma"
str2 = "rakuma"
p str1.object_id
p str2.object_id
p str1.equal?(str2) #同じオブジェクトならtrue、別のオブジェクトならfalseを返す

↓結果

23122440
23122420
false #同じidではなかった→文字列の場合2つのオブジェクトが作成されている
```

シンボルの場合
```rb
sym1 = :rakuma
sym2 = :rakuma
p sym1.object_id
p sym2.object_id
p sym1.equal?(sym2)  #同じオブジェクトならtrue、別のオブジェクトならfalseを返す

↓ 結果

892188
892188
true #同じidだった→シンボルの場合は1つしかオブジェクトが作成されていない
```

### RailsのModelオブジェクト

#### 主なfunction
[参考](https://railsdoc.com/model)
[GitHub](https://github.com/rails/rails/blob/f33d52c95217212cbacc8d5e44b5a8e3cdc6f5b3/activerecord/lib/active_record/associations/collection_proxy.rb)

| 機能 | 呼び出し方 |
| --- | --- |
| モデルを生成 | `model.new()` |
| モデルを生成して保存 | `model.create()` |
| DBに保存 | `model.save()` |
| DBを更新 | `model.update(id, 属性)` |
| IDを指定してレコードを取得 | `model.find(件数)` |
| 全てのレコードを取得 | `model.all` |
| 条件に当てはまる値を全て取得 | `model.where(条件)` |
| 取得した値を並び替え | `model.order(:キー名 [ :並び順])` |
| 取得するレコード数の上限を指定 | `model.limit(最大取得行数)` |
| ActiveRecordを利用して指定した条件のレコードを削除 | `model.destroy(条件)` |

### routes

resourcesを設定するとrailsで基本となる7つのアクションへのルーティングが定義できる

| 閲覧 | index  | show   |
| 生成 | new    | create |
| 更新 | edit   | update |
| 削除 | delete |        |

onlyを指定することで必要なルーティングのみに絞ることができる 
`routes :{controller name}, only: [:index, :show]`

