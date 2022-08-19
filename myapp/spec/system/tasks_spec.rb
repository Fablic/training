require 'rails_helper'

describe 'タスク管理機能', type: :system do
  # タスクを作成
  let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', status: 0, label: '1') }
  let!(:task_b) { FactoryBot.create(:task, title: '２つ目のタスク', description: '２つ目のタスクを実施する', status: 0, label: '2') }
  # タスクが表示される期待動作を共通化
  shared_examples_for 'タスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end
  shared_examples_for '２つ目のタスクが表示される' do
    it { expect(page).to have_content '２つ目のタスク' }
  end

  describe '一覧表示機能' do
    context 'タスクが1件存在する場合' do
      before do
        # 確認するパス（URL）を設定
        visit tasks_path
      end

      it_behaves_like 'タスクが表示される'
    end

    context 'タスクが2件(複数)存在する場合' do
      before do
        visit tasks_path
      end

      it_behaves_like 'タスクが表示される'
      it_behaves_like '２つ目のタスクが表示される'
    end
  end

  describe '詳細表示機能' do
    context 'タスクが存在する場合' do
      before do
        visit task_path(task_a)
      end

      it '各項目が表示される' do
        expect(page).to have_content '最初のタスク'
        expect(page).to have_content '最初のタスクを実施する'
        expect(page).to have_content 0
        expect(page).to have_content '1'
      end
    end
  end

  describe '新規登録機能' do
    before do
      visit new_task_path
      fill_in 'textarea1', with: title
      fill_in 'textarea2', with: description
    end

    context 'タスクの内容を入力した場合' do
      let(:title) { '新規作成のテスト' }
      let(:description) { '新規作成のテストを書く' }

      it 'タスクが正常に作成される' do
        # DBに登録されている
        expect { click_button 'submit' }.to change(Task, :count).by(1)
        # 画面で入力された内容でDBに登録されている
        task = Task.find_by(title: title)
        expect(task.title).to eq(title)
        expect(task.description).to eq(description)
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: '新規作成のテスト'
        # タスク一覧画面が表示される
        expect(current_path).to eq tasks_path
      end
    end
  end

  describe '編集機能' do
    before do
      visit edit_task_path(task_a)
    end

    context 'タスクの各項目を更新した場合' do
      let(:title) { '新規作成のテスト２' }
      let(:description) { '新規作成のテストを書く２' }

      it 'タスクが正常に更新される' do
        # 画面表示時に編集前のタスク内容が各項目に表示されている
        expect(page).to have_field 'textarea1', with: task_a.title
        expect(page).to have_field 'textarea2', with: task_a.description
        # 更新処理
        fill_in 'textarea1', with: title
        fill_in 'textarea2', with: description
        click_button 'submit'
        # 画面で入力された内容でDBのデータが更新されている
        task = Task.find_by(title: title)
        expect(task.title).to eq(title)
        expect(task.description).to eq(description)
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: '新規作成のテスト２'
      end
    end
  end

  describe '削除機能' do
    before do
      visit task_path(task_a)
    end

    context 'タスクを削除した場合' do
      it 'タスクが正常に削除される' do
        # DBの該当データが削除される
        expect { click_on('削除') }.to change(Task, :count).by(-1)
        expect(Task.find_by(title: task_a.title)).to be nil

        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: '削除しました'
      end
    end
  end

  describe 'ページ遷移' do
    context 'タスク一覧画面から詳細画面へ遷移' do
      before do
        visit tasks_path
        click_link '詳細リンク', match: :first
      end
      it '詳細画面へ遷移できること' do
        expect(current_path).to eq task_path(task_a)
      end
    end

    context '一覧画面から新規登録画面へ遷移' do
      before do
        visit tasks_path
        click_link '新規登録'
      end
      it '新規登録画面へ遷移できる' do
        expect(current_path).to eq new_task_path
      end
    end

    context '新規登録画面からタスク一覧画面へ遷移' do
      before do
        visit new_task_path
        click_link '一覧に戻る'
      end
      it '一覧画面へ遷移できる' do
        expect(current_path).to eq tasks_path
      end
    end

    context '詳細画面からタスク一覧画面へ遷移' do
      before do
        visit task_path(task_a)
        click_link '一覧に戻る'
      end
      it '一覧画面へ遷移できる' do
        expect(current_path).to eq tasks_path
      end
    end

    context '詳細画面から編集画面へ遷移' do
      before do
        visit task_path(task_a)
        click_link '編集'
      end
      it '編集画面へ遷移できる' do
        expect(current_path).to eq edit_task_path(task_a)
      end
    end

    context '編集画面から一覧画面へ遷移' do
      before do
        visit edit_task_path(task_a)
        click_link '一覧に戻る'
      end
      it '詳細画面へ遷移できる' do
        expect(current_path).to eq tasks_path
      end
    end
  end
end
