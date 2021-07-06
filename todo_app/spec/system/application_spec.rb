# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ApplicationController', type: :system do
  describe 'エラーハンドリング', :require_login do
    context '存在しないパスにアクセスするとき' do
      it '404ページが表示されること' do
        visit '/hoge'

        expect(page).to have_content 'ご指定のページが見つかりませんでした。'
      end
    end

    context 'レコードが存在しないパスにアクセスするとき' do
      it '404ページが表示されること' do
        visit task_path(0)

        expect(page).to have_content 'ご指定のページが見つかりませんでした。'
      end
    end

    context 'システムエラーが発生したとき' do
      it '500ページが表示されること' do
        allow_any_instance_of(TasksController).to receive(:index).and_throw(StandardError)
        visit root_path

        expect(page).to have_content '誠に申し訳ありません。ページに何らかのエラーが起きました。'
      end
    end
  end

  describe 'URLハンドリング' do
    describe 'ログイン時', :require_login do
      it '/loginアクセス時にrootに遷移する' do
        visit login_path

        expect(current_url).to match root_path
      end
    end

    describe '未ログイン時' do
      it 'rootアクセス時に/loginに遷移する' do
        visit root_path

        expect(current_url).to match login_path
      end
    end
  end
end
