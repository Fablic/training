require 'rails_helper'

RSpec.describe User, type: :system do
  let!(:user_taro) { create(:user, name: 'hogehoge', email: 'hoge@hoge.com', password: 'password') }
  let!(:user_jiro) { create(:user, name: 'testest', email: 'test@hoge.com', password: 'password') }

  before do
    login(user_taro.email, user_taro.password)
  end

  describe 'ユーザー一覧画面表示' do
    before do
      visit users_path
    end

    context 'ユーザー一覧ページにアクセスしたとき' do
      it 'ユーザー一覧の画面が表示される' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content user_taro.id
        expect(page).to have_content user_taro.name
        expect(page).to have_content user_taro.email
        expect(page).to have_content user_taro.tasks.length
        expect(page).to have_content (I18n.l(user_taro.created_at, format: :short))
        expect(page).to have_content (I18n.l(user_taro.updated_at, format: :short))
        expect(page).to have_link '詳細', href: "/admin/users/#{user_taro.id}"
        expect(page).to have_link '編集', href: "/admin/users/#{user_taro.id}/edit"
        expect(page).to have_link '削除', href: "/admin/users/#{user_taro.id}"
        expect(page).to have_content user_jiro.id
        expect(page).to have_content user_jiro.name
        expect(page).to have_content user_jiro.email
        expect(page).to have_content user_jiro.tasks.length
        expect(page).to have_content (I18n.l(user_jiro.created_at, format: :short))
        expect(page).to have_content (I18n.l(user_jiro.updated_at, format: :short))
        expect(page).to have_link '詳細', href: "/admin/users/#{user_jiro.id}"
        expect(page).to have_link '編集', href: "/admin/users/#{user_jiro.id}/edit"
        expect(page).to have_link '削除', href: "/admin/users/#{user_jiro.id}"
        expect(page).to have_link 'ユーザー新規登録'
        expect(page).to have_link 'タスクリスト'
        expect(page).to have_selector('span', text: "#{user_taro.name}")
        expect(page).to have_link 'ログアウト'

        within '.users' do
          users_name = all('.user-name').map(&:text)
          expect(users_name).to eq %w[testest hogehoge]
        end
      end
    end
  end

  describe 'ページング機能' do
    before do
      create(:user, name: 'user1')
      create(:user, name: 'user2')
      create(:user, name: 'user3')
      create(:user, name: 'user4')
      visit users_path
    end

    context 'ユーザー情報が５件以上あったとき' do
      it '２ページ目にユーザーが表示される' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_selector('a', text: 'Next')
        expect(page).to have_link 'Next'
        expect(page).to have_selector('a', text: 'Last')
        expect(page).to have_link 'Last'
        expect(page).to have_selector('a', text: '2')
        expect(page).to have_link '2'

        within '.users' do
          users_name = all('.user-name').map(&:text)
          expect(users_name).to eq %w[user4 user3 user2 user1 testest]
        end

        find_link('2').click

        expect(page).to have_content user_taro.id
        expect(page).to have_content user_taro.name
        expect(page).to have_content user_taro.email
        expect(page).to have_content user_taro.tasks.length
        expect(page).to have_content (I18n.l(user_taro.created_at, format: :short))
        expect(page).to have_content (I18n.l(user_taro.updated_at, format: :short))
        expect(page).to have_link '詳細', href: "/admin/users/#{user_taro.id}"
        expect(page).to have_link '編集', href: "/admin/users/#{user_taro.id}/edit"
        expect(page).to have_link '削除', href: "/admin/users/#{user_taro.id}"
        expect(page).to have_link 'First'
        expect(page).to have_link 'Previous'
        expect(page).to have_link '1'
      end
    end
  end

  describe 'ユーザー詳細画面表示' do
    let!(:task1) { create(:task, user_id: user_jiro.id) }
    let!(:task2) { create(:task, user_id: user_taro.id) }
    let!(:task3) { create(:task, user_id: user_taro.id) }

    before do
      visit user_path(user_taro.id)
    end

    context 'ユーザー詳細ページにアクセスしたとき' do
      it 'ユーザー詳細の画面が表示される' do
        expect(page).to have_current_path user_path(user_taro.id), ignore_query: true
        expect(page).to have_content user_taro.id
        expect(page).to have_content user_taro.name
        expect(page).to have_content user_taro.email
        expect(page).to have_content user_taro.tasks.length
        expect(page).to have_content user_taro.created_at
        expect(page).to have_content user_taro.updated_at
        expect(page).to have_link '編集', href: "/admin/users/#{user_taro.id}/edit"
        expect(page).to have_link 'ユーザーリスト', href: '/admin/users'

        expect(page).to have_content task2.id
        expect(page).to have_content task2.title
        expect(page).to have_content task2.content
        expect(page).to have_content (I18n.l(task2.deadline, format: :short))
        expect(page).to have_content (I18n.t("enums.task.status.#{task2.status}"))
        expect(page).to have_content (I18n.l(task2.created_at, format: :short))
        expect(page).to have_content (I18n.l(task2.updated_at, format: :short))
        expect(page).to have_content task3.id
        expect(page).to have_content task3.title
        expect(page).to have_content task3.content
        expect(page).to have_content (I18n.l(task3.deadline, format: :short))
        expect(page).to have_content (I18n.t("enums.task.status.#{task2.status}"))
        expect(page).to have_content (I18n.l(task3.created_at, format: :short))
        expect(page).to have_content (I18n.l(task3.updated_at, format: :short))
      end
    end

    context 'ユーザー情報がないとき' do
      before do
        visit users_path
        user_jiro.destroy
        click_link '詳細', href: "/admin/users/#{user_jiro.id}"
      end

      it 'ユーザー情報の詳細ページ表示されない' do
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'ユーザー新規登録画面表示' do
    before do
      visit new_user_path
    end

    context 'ユーザー新規登録ページにアクセスしたとき' do
      it 'ユーザー新規登録の画面が表示される' do
        expect(page).to have_current_path new_user_path, ignore_query: true
        expect(page).to have_field 'user[name]'
        expect(page).to have_field 'user[email]'
        expect(page).to have_field 'user[password]'
        expect(page).to have_field 'user[password_confirmation]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end
    end
  end

  describe 'ユーザー登録' do
    before do
      visit new_user_path
      fill_in 'user[name]', with: 'test子'
      fill_in 'user[email]', with: 'test@test.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
    end

    context '正しい情報を入力したとき' do
      before do
        click_button '登録'
      end

      it 'ユーザー登録できる' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('messages.create', model_name: I18n.t('activerecord.models.user')))
      end
    end

    context 'nameを入力しなかったとき' do
      before do
        fill_in 'user[name]', with: ''
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content '氏名を入力してください'
      end
    end

    context 'emailを入力しなかったとき' do
      before do
        fill_in 'user[email]', with: ''
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'emailに256文字以上入力したとき' do
      before do
        fill_in 'user[email]', with: "#{'a' * 256}" + '@test.com'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'メールアドレスは255文字以内で入力してください'
      end
    end

    context '登録済みのメールアドレスを入力したとき' do
      before do
        fill_in 'user[email]', with: user_taro.email
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'メールアドレスはすでに存在します'
      end
    end

    context 'メールアドレスフォーマット以外を入力したとき' do
      before do
        fill_in 'user[email]', with: '@testtest.com'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'パスワードが空欄のとき' do
      before do
        fill_in 'user[password]', with: ''
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'パスワードを入力してください'
      end
    end

    context 'パスワードが7文字で入力したとき' do
      before do
        fill_in 'user[password]', with: 'passwor'
        fill_in 'user[password_confirmation]', with: 'passwor'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'パスワードは8文字以上で入力してください'
      end
    end

    context 'パスワード、パスワード確認が異なる値で入力されたとき' do
      before do
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'passwor'
        click_button '登録'
      end

      it 'ユーザー登録できない' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
      end
    end
  end

  describe 'ユーザー編集画面表示' do
    before do
      visit edit_user_path(user_jiro.id)
    end

    context 'ユーザー編集ページにアクセスしたとき' do
      it 'ユーザー編集の画面が表示される' do
        expect(page).to have_current_path edit_user_path(user_jiro.id), ignore_query: true
        expect(page).to have_field 'user[name]'
        expect(page).to have_field 'user[email]'
        expect(page).to have_field 'user[password]'
        expect(page).to have_field 'user[password_confirmation]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end
    end

    context '編集するユーザー情報がないとき' do
      before do
        visit users_path
        user_jiro.destroy
        click_link '編集', href: "/admin/users/#{user_jiro.id}/edit"
      end

      it 'ユーザー情報の編集ページが表示されない' do
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'ユーザー編集' do
    before do
      visit edit_user_path(user_jiro.id)
      fill_in 'user[name]', with: 'test男'
      fill_in 'user[email]', with: 'test@test.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
    end

    context '正しい情報を入力したとき' do
      before do
        click_button '登録'
      end

      it 'ユーザー情報の更新ができる' do
        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('messages.update', model_name: I18n.t('activerecord.models.user')))
      end
    end

    context 'nameを入力しなかったとき' do
      before do
        fill_in 'user[name]', with: ''
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path user_path(user_jiro.id), ignore_query: true
        expect(page).to have_content '氏名を入力してください'
      end
    end

    context 'emailを入力しなかったとき' do
      before do
        fill_in 'user[email]', with: ''
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path user_path(user_jiro.id), ignore_query: true
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'emailに256文字以上入力したとき' do
      before do
        fill_in 'user[email]', with: "#{'a' * 256}" + '@test.com'
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path user_path(user_jiro.id), ignore_query: true
        expect(page).to have_content 'メールアドレスは255文字以内で入力してください'
      end
    end

    context '登録済みのメールアドレスを入力したとき' do
      before do
        fill_in 'user[email]', with: user_taro.email
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path user_path(user_jiro.id), ignore_query: true
        expect(page).to have_content 'メールアドレスはすでに存在します'
      end
    end

    context 'メールアドレスフォーマット以外を入力したとき' do
      before do
        fill_in 'user[email]', with: '@testtest.com'
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path user_path(user_jiro.id), ignore_query: true
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'パスワードが空欄のとき' do
      before do
        fill_in 'user[password]', with: ''
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path user_path(user_jiro.id), ignore_query: true
        expect(page).to have_content 'パスワードを入力してください'
      end
    end

    context 'パスワードが7文字で入力したとき' do
      before do
        fill_in 'user[password]', with: 'passwor'
        fill_in 'user[password_confirmation]', with: 'passwor'
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path user_path(user_jiro.id), ignore_query: true
        expect(page).to have_content 'パスワードは8文字以上で入力してください'
      end
    end

    context 'パスワード、パスワード確認が異なる値で入力されたとき' do
      before do
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'passwor'
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path user_path(user_jiro.id), ignore_query: true
        expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
      end
    end

    context '更新するユーザー情報がないとき' do
      before do
        user_jiro.destroy
        click_button '登録'
      end

      it 'ユーザー情報の更新ができない' do
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'ユーザー削除' do
    let!(:task) { create(:task, user_id: user_jiro.id) }

    context '削除ユーザーがある' do
      it 'ユーザーの削除に成功' do
        expect(User.all.length).to eq 2
        expect(Task.all.length).to eq 1

        visit users_path

        expect(page).to have_link '削除'
        click_link '削除', href: "/admin/users/#{user_jiro.id}"

        expect(page).to have_current_path users_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('messages.delete', model_name: I18n.t('activerecord.models.user')))
        expect(page).not_to have_content user_jiro.email
        expect(User.all.length).to eq 1
        expect(Task.all.length).to eq 0
      end
    end

    context '削除タスクがない' do
      it '該当するリソースがないと表示' do
        expect(User.all.length).to eq 2
        expect(Task.all.length).to eq 1

        visit users_path

        user_jiro.destroy
        click_link '削除', href: "/admin/users/#{user_jiro.id}"

        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_selector('.alert-danger', text: I18n.t('error.messages.record_not_found'))
        expect(page).not_to have_content user_jiro.email
        expect(User.all.length).to eq 1
        expect(Task.all.length).to eq 0
      end
    end
  end
end
