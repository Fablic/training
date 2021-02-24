# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Maintenance', type: :system do
  describe 'maintenance' do
    after { system('bundle exec rails runner lib/script/maintenance.rb 0') }
    shared_examples 'メンテナンスモードの切り替え処理が実行されない' do
      example do
        get login_path
        expect(response).to have_http_status 200
        visit login_path
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログイン'
        expect(page).not_to have_content '現在メンテナンス中です。'
      end
    end

    context '第一引数が1の場合(メンテナンスモード有効)' do
      example 'メンテナンスモードを開始し、タスク管理システムにアクセス不可となる' do
        system('bundle exec rails runner lib/script/maintenance.rb 1')
        get login_path
        expect(response).to have_http_status 503
        visit login_path
        expect(page).to have_content '現在メンテナンス中です。'
      end
    end

    context '第一引数が0の場合(メンテナンスモード無効)' do
      system('bundle exec rails runner lib/script/maintenance.rb 0')
      it_behaves_like 'メンテナンスモードの切り替え処理が実行されない'
    end

    context '第一引数が 0(無効) or 1(有効) 以外の場合' do
      system('bundle exec rails runner lib/script/maintenance.rb 3')
      it_behaves_like 'メンテナンスモードの切り替え処理が実行されない'
    end

    context '第一引数が無い場合' do
      system('bundle exec rails runner lib/script/maintenance.rb')
      it_behaves_like 'メンテナンスモードの切り替え処理が実行されない'
    end
  end
end
