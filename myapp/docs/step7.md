### ステップ7: タスクを登録・更新・削除できるようにしよう

- タスクの一覧画面、作成画面、詳細画面、編集画面を作成しましょう
  - `rails generate` コマンドでコントローラとビューを作成します

#Create Controller
bundle exec rails g controller Tasks new

  - コントローラとビューに必要な実装を追加しましょう

参考：https://rails-study.net/form_for/

  - 作成、更新、削除後はそれぞれflashメッセージを画面に表示させましょう
https://techacademy.jp/magazine/7286

- `routes.rb` を編集して、 `http://localhost:3000/` でタスクの一覧画面が表示されるようにしましょう
vim config/routes.rb 

参考：https://www.sejuku.net/blog/13078
参考：http://code24h.com/ruby-on-rails-d7342.htm

＃ルート確認
rails routes

#サーバー起動
ßrails s -b localhost -P 3000

#Routes確認
http://localhost:3000/rails/info/routes

#データ投入
vim db/seeds.rb
rake db:seed

#画面表示
http://localhost:3000/

- `Gemfile` で [RuboCop](https://github.com/rubocop/rubocop)（Rubyの静的コード解析ツール） か [fablicop](https://github.com/Fablic/fablicop)をインストールしましょう。設定やコマンド実行方法は各READMEから確認しましょう。
# check
rubocop
# 修正
rubocop --auto-correct
rubocop -A

- GitHub上でPRを作成してレビューしてもらいましょう
  - 今後、PRが大きくなりそうだったらPRを2回以上に分けることを検討しましょう

