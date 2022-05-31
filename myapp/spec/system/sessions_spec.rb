require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let!(:user) { FactoryBot.create(:normal_user) }

  describe 'ログイン処理' do
    before {visit login_path}
    context '登録済みのemail、正しいパスワードを入力' do
      it '正常にログインが行われ、トップページが表示されること' do
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'
        expect(current_path).to eq root_path
      end
    end

    context '登録していないメールアドレスを入力' do
      it 'ログインが行われないこと' do
        fill_in 'session_email', with: 'sample@gmail.com'
        fill_in 'session_password', with: user.password
        click_button 'ログイン'
        expect(current_path).to eq login_path
      end
    end

    context '間違ったパスワードを入力' do
      it 'ログインが行われないこと' do
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: 'samplepass'
        click_button 'ログイン'
        expect(current_path).to eq login_path
      end
    end
  end

  describe 'ログインしていないユーザー' do
    context 'タスク一覧のパスにアクセスした時' do
      it 'アクセスできず、ログインページに遷移させられること' do
        visit tasks_path
        expect(current_path).to eq login_path
      end
    end

    context 'タスク新規作成のパスにアクセスした時' do
      it 'アクセスできず、ログインページに遷移させられること' do
        visit new_task_path
        expect(current_path).to eq login_path
      end
    end
  end

  describe "ログアウト処理" do
    context "ログアウトボタンがクリックされた時" do
      it 'ログアウトが正常に行えること' do
        visit login_path
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        click_button 'ログイン'
        find('#dropdownMenuLink').click
        find('#logoutLink').click
        expect(current_path).to eq login_path
        visit new_task_path
        expect(current_path).to eq login_path
      end
    end
  end
  
end
