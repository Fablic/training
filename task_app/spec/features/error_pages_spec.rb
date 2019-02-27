# frozen_string_literal: true

require 'rails_helper'

feature 'エラー画面の表示機能(非ログイン状態)', type: :feature do
  shared_examples 'エラー画面が表示される' do |path, http_status, content|
    before { visit path }
    it { expect(page).to have_content "#{http_status}:#{content}" }
  end

  context '/403にアクセスしたとき' do
    it_behaves_like 'エラー画面が表示される', '/403', 403, '指定されたページへのアクセスは禁止されています'
  end

  context '/404にアクセスしたとき' do
    it_behaves_like 'エラー画面が表示される', '/404', 404, 'お探しのページは見つかりませんでした'
  end

  context '/hogeにアクセスしたとき' do
    it_behaves_like 'エラー画面が表示される', '/hoge', 404, 'お探しのページは見つかりませんでした'
  end

  context '/422にアクセスしたとき' do
    it_behaves_like 'エラー画面が表示される', '/422', 422, 'このページは表示できません'
  end

  context '/500にアクセスしたとき' do
    it_behaves_like 'エラー画面が表示される', '/500', 500, '一時的なエラーが発生しました'
  end
end

feature 'エラー画面の表示機能(ログイン状態)', type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  shared_examples '内部エラーによりエラー画面が表示される' do |http_status, content|
    before do
      allow(Task).to receive(:all).and_raise(error)
      login(user)
    end
    it { expect(page).to have_content "#{http_status}:#{content}" }
  end

  shared_examples 'Forbidden(403)によるエラー画面が表示される' do
    before { login(user, visit_path) }
    it { expect(page).to have_content '403:指定されたページへのアクセスは禁止されています' }
  end

  context 'ActiveRecord::RecordInvalidを発生させたとき(422)' do
    it_behaves_like '内部エラーによりエラー画面が表示される', 422, 'このページは表示できません' do
      let(:error) { ActiveRecord::RecordInvalid }
    end
  end

  context 'ActiveRecord::RecordNotUniqueを発生させたとき(422)' do
    it_behaves_like '内部エラーによりエラー画面が表示される', 422, 'このページは表示できません' do
      let(:error) { ActiveRecord::RecordNotUnique }
    end
  end

  context 'StandardErrorを発生させたとき(500)' do
    it_behaves_like '内部エラーによりエラー画面が表示される', 500, '一時的なエラーが発生しました' do
      let(:error) { StandardError }
    end
  end

  context '一般ユーザが管理画面にアクセスしたとき' do
    let(:task) { FactoryBot.create(:task, user: user) }
    let(:label) { FactoryBot.create(:label) }

    it_behaves_like 'Forbidden(403)によるエラー画面が表示される' do
      let(:visit_path) { admin_users_path }
    end

    it_behaves_like 'Forbidden(403)によるエラー画面が表示される' do
      let(:visit_path) { new_admin_user_path }
    end

    it_behaves_like 'Forbidden(403)によるエラー画面が表示される' do
      let(:visit_path) { tasks_admin_user_path(user) }
    end

    it_behaves_like 'Forbidden(403)によるエラー画面が表示される' do
      let(:visit_path) { edit_admin_user_path(task) }
    end
  end
end
