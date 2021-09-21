require 'rails_helper'

RSpec.describe 'index', js: true, type: :system do
  let!(:test_user) { create(:user) }
  let!(:task) { create(:task) }
  let!(:label) { create(:label, user_id: test_user.id, name: 'test_label') }

  before do
    visit login_path
    fill_in 'Name', with: test_user.name
    fill_in 'Password', with: test_user.password
    click_button 'ログイン'
  end

  describe 'ラベル管理ページ' do
    before { visit labels_path }
    subject { page }

    it '一覧が表示されている' do
      is_expected.to have_title('ラベル管理 | タスク管理')
      is_expected.to have_field 'label_name', with: label.name
    end
    it 'タスク一覧へ遷移する' do
      click_link 'タスク一覧'
      is_expected.to have_current_path root_path
    end
    context '削除実行する' do
      it '削除される' do
        page.accept_confirm('本当によろしいですか？') do
          click_link '削除', match: :first
        end
        is_expected.to have_content 'ラベルが削除されました'
        is_expected.to have_current_path labels_path
        is_expected.not_to have_field 'label_name', with: label.name
      end
    end
    context '削除実行しない' do
      it '削除されない' do
        page.dismiss_confirm('本当によろしいですか？') do
          click_link '削除', match: :first
        end
        is_expected.to have_current_path labels_path
        is_expected.to have_field 'label_name', with: label.name
      end
    end
  end

  describe 'ラベル新規作成' do
    before { visit labels_path }
    subject { page }
    let(:params) { { name: 'newlabel' } }

    context '入力エラーなし' do
      it 'ラベルが作成できる' do
        within '.new' do
          fill_in 'label_name', with: params[:name]
        end
        click_button '登録'
        is_expected.to have_content 'ラベル登録が成功しました'
        is_expected.to have_field 'label_name', with: params[:name]
        is_expected.to have_current_path labels_path
      end
    end
    context 'ラベルが未入力' do
      it 'エラーが表示される' do
        within '.new' do
          fill_in 'label_name', with: ''
        end
        click_button '登録'
        is_expected.to have_content 'ラベル登録が失敗しました'
        is_expected.to have_content 'ラベルを入力してください'
        is_expected.not_to have_field 'label_name', with: params[:name]
        is_expected.to have_current_path labels_path
      end
    end
  end

  describe 'ラベル更新' do
    before { visit labels_path }
    subject { page }
    let(:params) { { name: 'updatename' } }

    context '入力エラーなし' do
      it 'ラベルを更新できる' do
        within '.update' do
          fill_in 'label_name', with: params[:name]
        end
        click_button '更新'
        is_expected.to have_content 'ラベル更新が成功しました'
        is_expected.to have_field 'label_name', with: params[:name]
        is_expected.not_to have_field 'label_name', with: label.name
        is_expected.to have_current_path labels_path
      end
    end
    context 'ラベルが未入力' do
      it 'エラーが表示される' do
        within '.update' do
          fill_in 'label_name', with: ''
        end
        click_button '更新'
        is_expected.to have_content 'ラベル更新が失敗しました'
        is_expected.to have_content 'ラベルを入力してください'
        is_expected.to have_field 'label_name', with: label.name
        is_expected.not_to have_field 'label_name', with: params[:name]
        is_expected.to have_current_path labels_path
      end
    end
  end

  describe 'タスク作成' do
    before { visit new_task_path }
    subject { page }

    it 'ラベル選択で詳細と一覧に表示される' do
      is_expected.to have_field label.name
      check label.name
      fill_in '件名', with: 'new 件名'
      fill_in '詳細', with: 'new 詳細'
      fill_in '終了期限', with: Time.current
      click_button '投稿'
      is_expected.to have_current_path task_path(task.id + 1)
      is_expected.to have_content label.name
      visit root_path
      is_expected.to have_content label.name
    end
  end

  describe 'タスク編集' do
    before { visit edit_task_path(task.id) }
    subject { page }

    it 'ラベル選択で詳細と一覧に表示される' do
      is_expected.to have_field label.name
      check label.name
      click_button '保存'
      is_expected.to have_current_path task_path(task.id)
      is_expected.to have_content label.name
      visit root_path
      is_expected.to have_content label.name
    end
  end

  describe '一覧画面でのラベル検索' do
    let!(:labelling) { create(:labelling, task_id: task.id, label_id: label.id) }
    let!(:label_other) { create(:label, user_id: test_user.id, name: 'test_other_label') }
    let!(:task_other) { create(:task) }
    let!(:labelling_other) { create(:labelling, task_id: task_other.id, label_id: label_other.id) }

    before { visit root_path }
    subject { page }

    it '選択したラベルで検索できる' do
      check "q_labels_id_eq_any_#{label.id}"
      click_button '検索'
      within('.task_list') do
        is_expected.to have_content label.name
        is_expected.to have_no_content label_other.name
      end
    end
  end
end
