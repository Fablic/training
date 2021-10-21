require 'rails_helper'

RSpec.feature 'sessions', type: :feature do
  feature 'ログインの実行', js: true do
    background do
      @test_user = FactoryBot.create(:user)
    end
    context '正しいメール・パスワードの組み合わせ' do
      scenario 'ルートページへ遷移する' do
        exec_login(@test_user.mail_address, @test_user.password)
        expect(page).to have_current_path(tasks_path)
      end
    end
    context '誤ったメール・パスワードの組み合わせ' do
      scenario 'ログイン画面へリダイレクトしエラーメッセージを出す' do
        exec_login(@test_user.mail_address, 'wrong password')
        expect(page).to have_current_path(sessions_login_path)
        expect(page).to have_content('認証情報に誤りがあります。')
      end
    end
  end

  feature 'タスクページへの遷移', js: true do
    background do
      @test_user = FactoryBot.create(:user)
    end
    context 'ログイン状態の時' do
      scenario '遷移できる' do
        valid_login(@test_user)
        visit tasks_path
        expect(page).to have_current_path(tasks_path)
      end
    end
    context 'ログインしていない状態の時' do
      scenario 'ログイン画面へリダイレクトされる' do
        visit tasks_path
        expect(page).not_to have_current_path(tasks_path)
        expect(page).to have_current_path(sessions_login_path)
        expect(page).to have_content 'ログインしてください。'
      end
    end
    context 'ログイン失敗後の状態' do
      scenario 'ログイン画面へリダイレクトされる' do
        exec_login(@test_user.mail_address, 'wrong password')
        visit tasks_path
        expect(page).not_to have_current_path(tasks_path)
        expect(page).to have_current_path(sessions_login_path)
        expect(page).to have_content 'ログインしてください。'
      end
    end
  end

  feature 'セッション状態の記憶テスト', type: :request do
    background do
      @test_user = FactoryBot.create(:user)
    end
    context '記憶する場合' do
      scenario 'cookieを保持している' do
        post sessions_login_path, params: {
          session: {
            mail_address: @test_user.mail_address,
            password: @test_user.password,
            remember_me: '1'
          }
        }
        expect(response.cookies['remember_token']).to_not eq nil
      end
    end
    context '記憶しない場合' do
      scenario 'cookieを保持しない' do
        post sessions_login_path, params: {
          session: {
            mail_address: @test_user.mail_address,
            password: @test_user.password,
            remember_me: '0'
          }
        }
        expect(response.cookies['remember_token']).to eq nil
      end
    end
  end
end
