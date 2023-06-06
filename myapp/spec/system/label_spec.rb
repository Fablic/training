require 'rails_helper'

RSpec.describe 'Label', type: :system do
  let!(:taro_label) { create(:label, user: user_taro) }
  let!(:jiro_label) { create(:label, user: user_jiro) }
  let(:user_taro) { create(:user, name: 'hoge', email: Faker::Internet.email, password: 'password') }
  let(:user_jiro) { create(:user, name: 'test', email: Faker::Internet.email, password: 'password') }

  before do
    login(user_taro.email, user_taro.password)
  end

  describe 'ラベル一覧画面表示' do
    before do
      visit labels_path
    end

    context 'ラベルのデータあるとき' do
      it '降順で表示する' do
        expect(page).to have_current_path labels_path, ignore_query: true
        expect(page).to have_content taro_label.id
        expect(page).to have_content taro_label.name
        expect(page).to have_content taro_label.tasks.length
        expect(page).to have_content (I18n.l(taro_label.created_at, format: :short))
        expect(page).to have_content taro_label.user.name
        expect(page).to have_link '詳細', href: "/labels/#{taro_label.id}"
        expect(page).to have_link '編集', href: "/labels/#{taro_label.id}/edit"
        expect(page).to have_link '削除', href: "/labels/#{taro_label.id}"
        expect(page).to have_content jiro_label.id
        expect(page).to have_content jiro_label.name
        expect(page).to have_content jiro_label.tasks.length
        expect(page).to have_content (I18n.l(jiro_label.created_at, format: :short))
        expect(page).to have_content jiro_label.user.name
        expect(page).to have_link '詳細', href: "/labels/#{jiro_label.id}"
        expect(page).not_to have_link '編集', href: "/labels/#{jiro_label.id}/edit"
        expect(page).not_to have_link '削除', href: "/labels/#{jiro_label.id}"
      end
    end
  end

  describe 'ページング機能' do
    before do
      create(:label, name: 'label1', user_id: user_jiro.id)
      create(:label, name: 'label2', user_id: user_jiro.id)
      create(:label, name: 'label3', user_id: user_taro.id)
      create(:label, name: 'label4', user_id: user_jiro.id)
      create(:label, name: 'label5', user_id: user_taro.id)
      visit labels_path
    end

    context 'ラベルが５件以上あったとき' do
      it '２ページ目にラベルが表示される' do
        expect(page).to have_current_path labels_path, ignore_query: true
        expect(page).to have_selector('a', text: 'Next')
        expect(page).to have_link 'Next'
        expect(page).to have_selector('a', text: 'Last')
        expect(page).to have_link 'Last'
        expect(page).to have_selector('a', text: '2')
        expect(page).to have_link '2'

        within '.labels' do
          labels_name = all('.label-name').map(&:text)
          expect(labels_name).to eq %w[label5 label4 label3 label2 label1]
        end

        find_link('2').click

        expect(page).to have_content taro_label.id
        expect(page).to have_content taro_label.name
        expect(page).to have_content taro_label.tasks.length
        expect(page).to have_content (I18n.l(taro_label.created_at, format: :short))
        expect(page).to have_content taro_label.user.name
        expect(page).to have_link '詳細', href: "/labels/#{taro_label.id}"
        expect(page).to have_link '編集', href: "/labels/#{taro_label.id}/edit"
        expect(page).to have_link '削除', href: "/labels/#{taro_label.id}"
        expect(page).to have_content jiro_label.id
        expect(page).to have_content jiro_label.name
        expect(page).to have_content jiro_label.tasks.length
        expect(page).to have_content (I18n.l(jiro_label.created_at, format: :short))
        expect(page).to have_content jiro_label.user.name
        expect(page).to have_link '詳細', href: "/labels/#{jiro_label.id}"
        expect(page).not_to have_link '編集', href: "/labels/#{jiro_label.id}/edit"
        expect(page).not_to have_link '削除', href: "/labels/#{jiro_label.id}"
        expect(page).to have_link 'First'
        expect(page).to have_link 'Previous'
        expect(page).to have_link '1'
      end
    end
  end

  describe 'ラベル詳細画面表示' do
    let!(:task1) { create(:task, user: user_jiro, labels: [jiro_label]) }
    let!(:task2) { create(:task, user: user_taro, labels: [taro_label]) }
    let!(:task3) { create(:task, user: user_taro, labels: [taro_label]) }

    before do
      visit label_path(taro_label.id)
    end

    context 'ラベル詳細ページにアクセスしたとき' do
      it '詳細の画面が表示される' do
        expect(page).to have_current_path label_path(taro_label.id), ignore_query: true
        expect(page).to have_content taro_label.id
        expect(page).to have_content taro_label.name
        expect(page).to have_content taro_label.created_at
        expect(page).to have_content taro_label.updated_at
        expect(page).to have_link '編集', href: "/labels/#{taro_label.id}/edit"
        expect(page).to have_link 'ラベルリスト', href: '/labels'

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

    context 'ラベル情報がないとき' do
      before do
        d_label = create(:label, user: user_taro, name: '削除用')
        visit labels_path
        d_label.destroy
        click_link '詳細', href: "/labels/#{d_label.id}"
      end

      it 'ラベルの詳細ページ表示されない' do
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'ラベル新規登録画面表示' do
    before do
      visit new_label_path
    end

    context 'ラベル新規登録ページにアクセスしたとき' do
      it '新規登録の画面が表示される' do
        expect(page).to have_current_path new_label_path, ignore_query: true
        expect(page).to have_field 'label[name]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end
    end
  end

  describe 'ラベル登録' do
    before do
      visit new_label_path
      fill_in 'label[name]', with: 'a' * 20
    end

    context '正しい情報を入力したとき' do
      before do
        click_button '登録'
      end

      it 'ラベル登録できる' do
        expect(page).to have_current_path labels_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('messages.create', model_name: I18n.t('activerecord.models.label')))
      end
    end

    context 'nameを入力しなかったとき' do
      before do
        fill_in 'label[name]', with: ''
        click_button '登録'
      end

      it 'ラベル登録できない' do
        expect(page).to have_current_path labels_path, ignore_query: true
        expect(page).to have_content 'ラベルを入力してください'
      end
    end

    context 'nameが21文字以上、入力したとき' do
      before do
        fill_in 'label[name]', with: 'a' * 21
        click_button '登録'
      end

      it 'ラベル登録できない' do
        expect(page).to have_current_path labels_path, ignore_query: true
        expect(page).to have_content 'ラベルは20文字以内で入力してください'
      end
    end

    context '登録済みのラベルを入力したとき' do
      before do
        create(:label, name: 'hoge', user: user_jiro)

        fill_in 'label[name]', with: 'hoge'
        click_button '登録'
      end

      it 'ラベル登録できない' do
        expect(page).to have_current_path labels_path, ignore_query: true
        expect(page).to have_content 'ラベルはすでに存在します'
      end
    end
  end

  describe 'ラベル編集画面表示' do
    before do
      visit edit_label_path(taro_label.id)
    end

    context '編集ページにアクセスしたとき' do
      it 'ラベル編集の画面が表示される' do
        expect(page).to have_current_path edit_label_path(taro_label.id), ignore_query: true
        expect(page).to have_field 'label[name]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end
    end

    context '編集するラベルがないとき' do
      before do
        d_label = create(:label, user: user_taro, name: '削除用')

        visit labels_path
        d_label.destroy
        click_link '編集', href: "/labels/#{d_label.id}/edit"
      end

      it 'ラベル情報の編集ページが表示されない' do
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'ラベル編集' do
    before do
      visit edit_label_path(taro_label.id)
      fill_in 'label[name]', with: 'test'
    end

    context '正しい情報を入力したとき' do
      before do
        click_button '登録'
      end

      it 'ラベルの更新ができる' do
        expect(page).to have_current_path labels_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('messages.update', model_name: I18n.t('activerecord.models.label')))
      end
    end

    context 'nameを入力しなかったとき' do
      before do
        fill_in 'label[name]', with: ''
        click_button '登録'
      end

      it 'ラベル登録できない' do
        expect(page).to have_current_path label_path(taro_label.id), ignore_query: true
        expect(page).to have_content 'ラベルを入力してください'
      end
    end

    context 'nameが21文字以上、入力したとき' do
      before do
        fill_in 'label[name]', with: 'a' * 21
        click_button '登録'
      end

      it 'ラベル登録できない' do
        expect(page).to have_current_path label_path(taro_label.id), ignore_query: true
        expect(page).to have_content 'ラベルは20文字以内で入力してください'
      end
    end

    context '登録済みのラベルを入力したとき' do
      before do
        create(:label, name: 'hoge', user: user_jiro)

        fill_in 'label[name]', with: 'hoge'
        click_button '登録'
      end

      it 'ラベル登録できない' do
        expect(page).to have_current_path label_path(taro_label.id), ignore_query: true
        expect(page).to have_content 'ラベルはすでに存在します'
      end
    end

    context '更新するラベルがないとき' do
      before do
        taro_label.destroy
        click_button '登録'
      end

      it 'ラベル情報の更新ができない' do
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'ラベル削除' do
    before do
      visit labels_path
    end

    context 'ラベル削除にアクセスしたとき' do
      it 'ラベル削除に成功' do
        expect(page).to have_link '削除'
        click_link '削除', href: "/labels/#{taro_label.id}"

        expect(page).to have_current_path labels_path, ignore_query: true
        expect(page).to have_selector('.alert-success', text: I18n.t('messages.delete', model_name: I18n.t('activerecord.models.label')))
        expect(page).not_to have_content taro_label.name
      end
    end

    context '削除ラベルがない' do
      before do
        taro_label.destroy
        click_link '削除', href: "/labels/#{taro_label.id}"
      end

      it '該当するリソースがないと表示' do
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_selector('.alert-danger', text: I18n.t('error.messages.record_not_found'))
      end
    end
  end
end
