### ステップ18: ユーザの管理画面を実装しよう ★ スキップ可能

- 画面上に管理メニューを追加しましょう
- 管理画面にはかならず `/admin` というURLを先頭につけるようにしましょう
  - `routes.rb` に追加する前に、あらかじめURLやルーティング名（ `*_path` となる名前）を想定して設計してみましょう
  https://www.sejuku.net/blog/13078
- ユーザ一覧・作成・更新・削除を実装しましょう
bundle exec rails generate model users
bundle exec rails g controller users new
bundle exec rails g erb:scaffold users

https://blog.cloud-acct.com/posts/u-rails-user-validates/
- ユーザを削除したら、そのユーザが抱えているタスクを削除するようにしてみましょう
- ユーザの一覧画面で、ユーザが持っているタスクの数を表示するようにしてみましょう
- ユーザが作成したタスクの一覧が見られるようにしてみましょう
