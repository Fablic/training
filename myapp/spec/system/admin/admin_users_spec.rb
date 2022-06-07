require 'rails_helper'
RSpec.describe 'AdminUsers', type: :system do 
  let!(:normal_user) { create(:normal_user) }
  let!(:task) { create(:task, user: normal_user) }

  let!(:admin_user) { create(:admin_user) }

  describe '管理権限を持つユーザーでログイン' do
    before do
      visit login_path
      fill_in 'session_email', with: admin_user.email
      fill_in 'session_password', with: admin_user.password
      click_button 'ログイン'
    end

    describe '一覧ページ' do
      before { visit admin_users_path }
      context 'アクセス時' do
        it '画面が正常に表示されること' do
          expect(page).to have_content normal_user.name
          expect(page).to have_content admin_user.name
        end

        it 'ユーザーに紐づくタスクの数が表示されていること' do
          expect(all('table tr td')[2].text).eql?(Task.where(user_id: normal_user.id).count)
        end
      end

      context 'タスク一覧をクリックしたとき' do
        it '正常に遷移できること' do
          all('table tr')[1].click_on 'タスク一覧'
          expect(current_path).to eq admin_user_tasks_path normal_user.id
        end
      end

      context '編集をクリックしたとき' do
        it '正常に遷移できること' do
          all('table tr')[1].click_on '編集'
          expect(current_path).to eq edit_admin_user_path normal_user.id
        end
      end

      context 'ユーザー追加をクリックしたとき' do
        it '正常に遷移できること' do
          click_on 'ユーザー追加'
          expect(current_path).to eq new_admin_user_path
        end
      end
      
      context '削除をクリックしたとき' do
        it 'ユーザーが正常に削除されること' do
          all('table tr')[1].click_on '削除'
          expect(User.where(id: normal_user.id)).not_to exist
        end

        it 'ユーザーに紐づくタスクも削除されること' do
          all('table tr')[1].click_on '削除'
          expect(Task.where(user_id: normal_user.id)).not_to exist
        end
      end
    end

    describe '新規作成ページ' do
      before { visit new_admin_user_path }
      context 'ユーザー新規作成時' do
        let!(:name) {'new user'}
        it 'ユーザー新規追加が正常に行われること' do
          fill_in 'user[name]', with: name
          fill_in 'user[email]', with: 'newuser@gmail.com'
          fill_in 'user[password]', with: 'password'
          click_button '保存'
          expect(User.where(name: name)).to exist
          expect(page).to have_content 'ユーザーを新規作成しました。'
        end
      end

      context '戻るボタンが押された時' do
        it '正常に遷移すること' do
          click_on '戻る'
          expect(current_path).to eq admin_users_path
        end
      end
    end

    describe '編集ページ' do
      before { visit edit_admin_user_path normal_user}

      context 'アクセスした時' do
        it '画面が正常に表示されること' do
          expect(page).to have_content 'ユーザー情報編集'
        end
      end

      context '更新した時' do
        it '更新が正常に行われること' do
          name = 'edit name'
          email = 'edit@gmail.com'
          password = 'changepass'
          fill_in 'user[name]', with: name
          fill_in 'user[email]', with: email
          fill_in 'user[password]', with: password
          check 'user[admin_flg]'
          click_button '保存'
          expect(page).to have_content 'ユーザー情報を更新しました。'
          current_user = User.find(normal_user.id)
          expect(current_user.name).to eq name
          expect(current_user.email).to eq email
          expect(current_user.admin_flg).to eq 1
          expect(current_user.authenticate(password)).not_to eq false
        end
      end

      context 'パスワードを空で更新した時' do
        it 'パスワードの更新が行われないこと' do
          check 'user[admin_flg]'
          click_button '保存'
          expect(page).to have_content 'ユーザー情報を更新しました。'
          current_user = User.find(normal_user.id)
          expect(current_user.authenticate(normal_user.password)).not_to eq false
        end
      end
    end

    describe 'ユーザータスク一覧画面' do
      before { visit admin_user_tasks_path normal_user.id }
      context 'アクセス時' do
        it '画面が正常に表示されること' do
          expect(page).to have_content task.title
        end
      end

      context '戻るボタンを押した時' do
        it 'ユーザー一覧画面に戻ること' do
          click_on '戻る'
          expect(current_path).to eq admin_users_path
        end
      end
    end
  end
  
  describe '一般ユーザーでログイン' do
    let!(:redirect_to) {tasks_path}
    before do
      visit login_path
      fill_in 'session_email', with: normal_user.email
      fill_in 'session_password', with: normal_user.password
      click_button 'ログイン'
    end
    
    describe '一覧ページ' do
      context 'アクセス時' do
        it 'アクセスできずリダイレクトされること' do
          visit admin_users_path
          expect(current_path).to eq redirect_to
        end
      end
    end

    describe '新規作成ページ' do
      context 'アクセス時' do
        it 'アクセスできずリダイレクトされること' do
          visit new_admin_user_path
          expect(current_path).to eq redirect_to
        end
      end
    end

    describe '編集ページ' do
      context 'アクセス時' do
        it 'アクセスできずリダイレクトされること' do
          visit edit_admin_user_path normal_user
          expect(current_path).to eq redirect_to
        end
      end
    end

    describe 'ユーザータスク一覧画面' do
      context 'アクセス時' do
        it 'アクセスできずリダイレクトされること' do
          visit admin_user_tasks_path normal_user.id
          expect(current_path).to eq redirect_to
        end
      end
    end
  end
end
