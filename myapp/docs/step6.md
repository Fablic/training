#実行コマンド
bundle exec rails generate model tasks
      invoke  active_record
      create    db/migrate/20211011074426_create_tasks.rb
      create    app/models/task.rb
      invoke    test_unit
      create      test/models/task_test.rb
      create      test/fixtures/tasks.yml

参考：https://www.javadrive.jp/rails/model/index4.html


vim db/migrate/20211011074426_create_tasks.rb


bundle exec rails generate model users
P48086:myapp ts-ken.a.ichinose$ bundle exec rails generate model users
Running via Spring preloader in process 48019
[WARNING] The model name 'users' was recognized as a plural, using the singular 'user' instead. Override with --force-plural or setup custom inflection rules for this noun before running the generator.
      invoke  active_record
      create    db/migrate/20211011163343_create_users.rb
      create    app/models/user.rb
      invoke    test_unit
      create      test/models/user_test.rb
      create      test/fixtures/users.yml
P48086:myapp ts-ken.a.ichinose$ pwd


vim db/migrate/20211011163343_create_users.rb


bundle exec rails db:migrate:redo VERSION=20211011163343
bundle exec rails db:migrate:redo VERSION=20211011074426

bundle exec rails dbconsole

bundle exec rails db:migrate


rails db:migrate:redo STEP=3


bundle exec rails db:rollback

https://www.sejuku.net/blog/60950√