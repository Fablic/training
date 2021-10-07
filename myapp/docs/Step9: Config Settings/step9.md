### ステップ9: アプリの各種設定を行いましょう

- 日本語部分を共通化
  - Railsのi18nの仕組みを利用して、日本語リソースの共通化をしましょう
  - ※i18n化を行うと後のステップでメッセージを出したりするのが楽になるなどのメリットがあります
- タイムゾーンの設定
  - Railsのタイムゾーンを日本（東京）に設定しましょう
- エラーページの設定
  - Railsが用意しているデフォルトのエラーページを自分が作った画面にしてみましょう
  - 状況に応じて、適切にエラーページを設定しましょう
  - ステータスコードの404ページと500ページの2種類の設定は少なくとも必須とします

## work log

### 日本語部分を共通化

#### `config/locales/ja.yml`の作成  
config/locales配下にある全ての`.rb`ファイルと`.yml`ファイルが自動的に訳文読み込みパスに追加される  
ここではviewの中で表示する日本語文字列の定義？辞書作成？を行う

```yml
ja:
  activerecord:
    attributes:
      task:
        title: 件名
        description: 詳細

  flash:
    create_success: タスク作成に成功しました
    create_danger: タスク作成に失敗しました
    updated_success: タスク編集に成功しました
    updated_danger: タスク編集に失敗しました
    destroy: タスクを削除しました
```


`*.erb`で設定した日本語文字列を利用
```erb
<%= form.label :title, 'タイトル' %>
↓
<%= form.label :title, t('task.title') %>

<%= form.label :description, '詳細' %>
↓
<%= form.label :description, t('task.description') %>
```

#### `config/application.rb`に以下を追加

```rb
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
```

動かない！！！！！！！！！！

各ファイルでの読み込み方法を変えたら動いた！
before
``
after
`task.title`


訳文は、シンボルまたは文字列のどちらをキーとして参照することもできます。したがって、以下の2つの呼び出しは等価です。
```rb
I18n.t :message
I18n.t 'message'
```
translateメソッドは:scopeオプションを取ることもできる

```rb
I18n.t :record_invalid, scope: [:activerecord, :errors, :messages]
```
上のコードでは、Active Recordエラーメッセージの:record_invalidメッセージを参照している

キーとスコープにはドットで区切ったキーを指定することもできる
```rb
I18n.translate "activerecord.errors.messages.record_invalid"
```
したがって、以下の4つの呼び出しはすべて等価

```rb
I18n.t 'activerecord.errors.messages.record_invalid'
I18n.t 'errors.messages.record_invalid', scope: :activerecord
I18n.t :record_invalid, scope: 'activerecord.errors.messages'
I18n.t :record_invalid, scope: [:activerecord, :errors, :messages]
```

#### フォルダ分け

model用の`ja.yml`とview用の`ja.yml`を作成
**※注意**  
この時一度アプリケーションをリスタートしないと`ja.yml`が読み込まれない


### タイムゾーンの設定

#### `config/application.rb`に以下を追加
[Ref: Railsガイド](https://railsguides.jp/i18n.html#rails%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E5%9B%BD%E9%9A%9B%E5%8C%96%E5%90%91%E3%81%91%E3%81%AB%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B)  

```rb
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local
```




### エラーページの設定

#### rescue_fromとは


`application_controller.rb` error page renderに関する記述追加
```rb
    rescue_from ActiveRecord::RecordNotFound,   with: :render_not_found
    rescue_from ActionController::RoutingError, with: :render_not_found
    rescue_from Exception,                      with: :render_server_error

    def routing_error
      raise ActionController::RoutingError, params[:path]
    end

    def render_not_found
      logger.info "Rendering 404 with excaption: #{exc.message}" if exc
      render file: Rails.root.join('public/404.html'), status: 404, layout: true, content_type: 'text/html'
    end
  
    def render_server_error
      logger.error "Rendering 500 with excaption: #{exc.message}" if exc
      render file: Rails.root.join('public/500.html'), status: 500, layout: true, content_type: 'text/html'
    end
  end
```

## What i learn

### What is 'i18n'??

アプリケーションの文言を英語以外の別の１つの言語に翻訳する機能を提供  
ローカライズする場合、日付や自国のフォーマット、ActiveRecordモデル名などが対象となる  
アプリケーションで使われる文字列を抽象化し、キーで検索できる辞書に保存する。フラッシュメッセージやview内の固定テキストなどが対象

config/locales配下にある全ての`.rb`ファイルと`.yml`ファイルが自動的に訳文読み込みパスに追加される

### エラーページは下にあるものから評価される

https://haayaaa.hatenablog.com/entry/2019/03/15/221455


### Exception関連はcontroller外でハンドリングされる

```
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
```
