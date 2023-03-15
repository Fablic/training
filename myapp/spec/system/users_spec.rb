require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) {
    create(:user, name: 'taro',
                  email: 'taro@hoge.hoge',
                  password: 'password')
  }

  before do
    driven_by(:remote_chrome)
    login(user.email, user.password)
  end

  describe 'CRUD' do
    describe 'GET /admin/users' do
      before do
        visit '/admin/users'
      end

      it 'shows users list' do
        expect(page).to have_content 'ユーザ 一覧'
        expect(page).to have_content 'taro@hoge.hoge'
        expect(page.all('table tbody tr').length).to eq 1
      end
    end

    describe 'GET /admin/users/:id' do
      it 'renders a successful response' do
        visit "/admin/users/#{user.id}"
        expect(page).to have_content 'ユーザ 詳細'
        expect(page).to have_content 'taro@hoge.hoge'
        expect(page).not_to have_content 'パスワード' # パスワードは表示しない
      end
    end

    describe 'GET /admin/users/new' do
      it 'renders users list page' do
        visit '/admin/users/new'
        expect(page).to have_content 'ユーザ 新規'
      end
    end

    describe 'GET /admin/users/:id/edit' do
      it 'renders a successful response' do
        visit "/admin/users/#{user.id}/edit"
        expect(page).to have_content 'ユーザ 編集'
        expect(page).to have_selector 'input[value="taro@hoge.hoge"]'
      end
    end

    describe 'Creating a new user' do
      before do
        visit '/admin/users'
        click_link('追加')
        fill_in 'user[name]', with: 'jiro'
        fill_in 'user[email]', with: 'jiro@hoge.hoge'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        find('input[type="submit"]').click
      end

      it 'successfully create a user' do
        expect(page).to have_content 'ユーザが正常に登録されました。'
        expect(page).to have_content 'ユーザ 詳細'
        expect(page).to have_content 'jiro@hoge.hoge'
      end
    end

    describe 'Updating a user' do
      let(:user2) {
        create(:user, name: 'jiro',
                      email: 'jiro@hoge.hoge',
                      password: 'password')
      }
      let(:new_email) { 'saburo@hoge.hoge' }
      let(:new_password) { 'passwordhogehoge' }

      before do
        visit "/admin/users/#{user2.id}/edit"
        fill_in 'user[name]', with: 'saburo'
        fill_in 'user[email]', with: new_email
        fill_in 'user[password]', with: new_password
        fill_in 'user[password_confirmation]', with: new_password
        find('input[type="submit"]').click
      end

      it 'successfully update a user' do
        expect(page).to have_content 'ユーザが正常に更新されました。'
        expect(page).to have_content 'ユーザ 詳細'
        expect(page).to have_content new_email
        expect(User.find_by(email: new_email).authenticate(new_password)).to be_present # パスワードが変更されたかテスト
      end
    end

    describe 'Deleting a user' do
      let(:user2) {
        create(:user, name: 'jiro',
                      email: 'jiro@hoge.hoge',
                      password: 'password')
      }

      before do
        create(:task, user: user2)
      end

      it 'successfully update a user' do
        expect(User.all.length).to eq 2
        expect(Task.all.length).to eq 1
        visit '/admin/users'
        # see: https://www.rubydoc.info/gems/capybara/Capybara%2FSession:accept_confirm
        page.accept_confirm do
          click_link('削除')
        end
        expect(page).to have_content 'ユーザが正常に削除されました。'
        expect(page).to have_content 'ユーザ 一覧'
        expect(page).not_to have_content 'jiro@hoge.hoge'
        expect(User.all.length).to eq 1
        expect(Task.all.length).to eq 0 # 削除されたユーザに紐づくタスクも削除されることをテスト
      end
    end
  end
end
