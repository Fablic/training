require 'rails_helper'

RSpec.describe 'index', js: true, type: :system do
  let!(:test_user) { create(:user) }
  let!(:task) { create(:task) }
  let!(:admin_user) { create(:admin_user) }
  before do
    visit login_path
    fill_in 'Name', with: admin_user.name
    fill_in 'Password', with: admin_user.password
    click_button 'ログイン'
  end

  describe 'ユーザ一覧ページ' do
    before { visit admin_users_path }
    subject { page }

    it '一覧が表示されている' do
      is_expected.to have_title('ユーザ管理：一覧 | タスク管理')
      is_expected.to have_content(admin_user.name)
      is_expected.to have_content(test_user.name)
    end
    it 'ログインしているユーザ（管理者）の削除ボタンは表示されない' do
      trs = page.all('tr')
      expect(trs[1]).to have_content '削除'
      expect(trs[2]).not_to have_content '削除'
    end

    it 'ユーザのタスク一覧へ遷移する' do
      click_link '1件'
      is_expected.to have_current_path admin_user_path(test_user.id)
    end
    it '新規作成へ遷移する' do
      click_link '新規ユーザ作成'
      is_expected.to have_current_path new_admin_user_path
    end
    it '更新へ遷移する' do
      click_link '更新', match: :first
      is_expected.to have_current_path edit_admin_user_path(test_user.id)
    end
    context '削除実行する' do
      it '削除される' do
        page.accept_confirm('本当によろしいですか？') do
          click_link '削除', match: :first
        end
        is_expected.to have_content 'ユーザ削除が成功しました'
        is_expected.to have_current_path admin_users_path
        is_expected.not_to have_content(test_user.name)
      end
    end
    context '削除実行しない' do
      it '削除されない' do
        page.dismiss_confirm('本当によろしいですか？') do
          click_link '削除', match: :first
        end
        is_expected.to have_current_path admin_users_path
        is_expected.to have_content(test_user.name)
      end
    end
  end

  describe 'ユーザタスク一覧ページ' do
    before { visit admin_user_path(test_user.id) }
    subject { page }

    it 'ユーザのタスク一覧が表示されている' do
      is_expected.to have_title('ユーザ管理：タスク一覧 | タスク管理')
      is_expected.to have_content(task.title)
    end
    it 'ユーザ一覧へ遷移する' do
      click_link 'ユーザ一覧に戻る'
      is_expected.to have_current_path admin_users_path
    end
  end

  describe '新規作成ページ' do
    before { visit new_admin_user_path }
    subject { page }
    let(:params) { { name: 'newname', password: 'password', role: 'user_role_admin' } }

    context '入力エラーなし' do
      it 'ユーザが作成できる' do
        is_expected.to have_title('ユーザ管理：新規 | タスク管理')
        fill_in 'ユーザ名', with: params[:name]
        fill_in 'パスワード', with: params[:password]
        choose params[:role]
        click_button '登録'
        is_expected.to have_content 'ユーザ登録が成功しました'
        is_expected.to have_content(params[:name])
        is_expected.to have_content '管理者', count: 2
        is_expected.to have_current_path admin_users_path
      end
    end
    context 'ユーザ名が未入力' do
      it 'エラーが表示される' do
        fill_in 'ユーザ名', with: ''
        fill_in 'パスワード', with: params[:password]
        choose params[:role]
        click_button '登録'
        is_expected.to have_content 'ユーザ登録が失敗しました'
        is_expected.to have_content 'ユーザ名を入力してください'
        is_expected.to have_current_path new_admin_user_path
      end
    end
    context 'パスワードが未入力' do
      it 'エラーが表示される' do
        fill_in 'ユーザ名', with: params[:name]
        fill_in 'パスワード', with: ''
        choose params[:role]
        click_button '登録'
        is_expected.to have_content 'ユーザ登録が失敗しました'
        is_expected.to have_content 'パスワードを入力してください'
        is_expected.to have_current_path new_admin_user_path
      end
    end
  end

  describe '更新ページ' do
    before { visit edit_admin_user_path(admin_user.id) }
    subject { page }
    let(:params) { { name: 'updatename', password: 'password', role: 'user_role_admin' } }

    it 'ユーザ名と種別が表示/選択され、パスワードは表示されない' do
      is_expected.to have_title('ユーザ管理：更新 | タスク管理')
      is_expected.to have_field 'ユーザ名', with: admin_user.name
      is_expected.to have_field 'パスワード', with: ''
      is_expected.to have_checked_field('user_role_admin')
    end
    context '入力エラーなし' do
      it 'ユーザを更新できる' do
        fill_in 'ユーザ名', with: params[:name]
        fill_in 'パスワード', with: params[:password]
        choose params[:role]
        click_button '更新'
        is_expected.to have_content 'ユーザ更新が成功しました'
        is_expected.to have_content(params[:name])
        is_expected.to have_current_path admin_users_path
      end
    end
    context 'ユーザ名が未入力' do
      it 'エラーが表示される' do
        fill_in 'ユーザ名', with: ''
        fill_in 'パスワード', with: params[:password]
        choose params[:role]
        click_button '更新'
        is_expected.to have_content 'ユーザ更新が失敗しました'
        is_expected.to have_content 'ユーザ名を入力してください'
        is_expected.to have_current_path edit_admin_user_path(admin_user.id)
      end
    end
    context 'パスワードが未入力' do
      it 'エラーが表示されず更新される' do
        fill_in 'ユーザ名', with: params[:name]
        fill_in 'パスワード', with: ''
        choose params[:role]
        click_button '更新'
        is_expected.to have_content 'ユーザ更新が成功しました'
        is_expected.to have_content(params[:name])
        is_expected.to have_current_path admin_users_path
      end
    end
    context '管理者が１人のとき' do
      it 'ユーザ種別を一般へ更新できない' do
        fill_in 'ユーザ名', with: params[:name]
        fill_in 'パスワード', with: params[:password]
        choose 'user_role_nomal'
        click_button '更新'
        is_expected.to have_content 'ユーザ更新が失敗しました'
        is_expected.to have_content '管理者は1人以上必要です'
        is_expected.to have_current_path edit_admin_user_path(admin_user.id)
      end
    end
  end
end
