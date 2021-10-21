### ステップ8: テスト(system spec)を書こう


- specを書くための準備をしましょう
  - `spec/spec_helper.rb` 、 `spec/rails_helper.rb` を用意しましょう

> - Rails 5.1 以降、新たにsystem testの機能を追加しました
#　system test利用のためrailsを5.1にアップ
＃ Gemfileを修正
ーーーーー
# gem 'rails', '~> 5.0.7'
gem 'rails', '~> 5.1'
ーーーーー
# UPDATE
bundle upadte


# 【トラブルシューティング】rails s が効かなくなった！！
以下を参照し解消
https://qiita.com/luglio22/items/0dd520f3748935bada81

# rspec導入
# FactoryBotも合わせて　
# Gemfileに追加
ーーーーー
group :development, :test do
 　# 〜 省略 〜
 　gem 'rspec-rails'
   gem 'factory_bot_rails', '~> 4.11'
end
　
group :test do
　 # ...
  gem 'capybara'
  gem 'selenium-webdriver'
end
ーーーーー
# INSTALL
bundle install
# 初期設定
bin/rails generate rspec:install

# ChromeとChromeDriverインストール（https://qiita.com/jnchito/items/c7e6e7abf83598a6516d）
brew install chromedriver
# 最新版にアップデート
brew upgrade chromedriver

# factories作成（FactoryBot）
rails g factory_bot:model task

http://vdeep.net/rubyonrails-rspec-factorybot-capybara

- ~~feature spec~~ system specをタスク機能に対して書きましょう
  - Rails 5.1 以降、新たにsystem testの機能を追加しました
    - [日本語](https://qiita.com/jnchito/items/c7e6e7abf83598a6516d), [英語](https://rossta.net/blog/why-rails-system-tests-matter.html)
  - feature specですと `database_cleaner` という gemは必要でしたが、 system specに変更することで `database_cleaner` の導入が要らなくなった


https://qiita.com/smbbc20/items/b9545e66af864b5faddb

# capybara利用のための設定追加
vim spec/spec_helper.rb
-----------
require 'capybara/spec'
config.before(:each, type: :system) do
  driven_by :selenium_chrome_headless
end
-----------
# テストファイル作成
rails g rspec:model tasks
rails g rspec:system tasks

# テスト実行
bundle exec rspec

# ［めも］confirm ボタンを押すやり方
https://k-koh.hatenablog.com/entry/2020/08/21/225715
- Circle CIなどのCIツールを導入して、Slackに通知するようにしましょう
  - Fablic/training内でPRのやり取りをする場合、CIツールの導入は任意(optional)です。CircleCIのAdmin権限が無いので、`.circleci/config.yml`を設定しても実行できないです。
- 参考書籍：https://leanpub.com/everydayrailsrspec-jp
