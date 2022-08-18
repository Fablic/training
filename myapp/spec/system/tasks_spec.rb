require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let!(:task_a) { FactoryBot.create(:task, name: 'タスク１', description: 'タスク１を実施する') }
  let!(:task_b) { FactoryBot.create(:task, name: 'タスク２', description: 'タスク２を実施する') }

  shared_examples_for '１つ目のタスクが表示される' do
    it { expect(page).to have_content 'タスク１' }
  end
  shared_examples_for '２つ目のタスクが表示される' do
    it { expect(page).to have_content 'タスク２' }
  end

  describe '一覧表示機能' do
    context 'タスクが1件存在する場合' do
      before do
        visit tasks_path
      end

      it_behaves_like '１つ目のタスクが表示される'
    end

    context 'タスクが2件存在する場合' do
      before do
        visit tasks_path
      end

      it_behaves_like '１つ目のタスクが表示される'
      it_behaves_like '２つ目のタスクが表示される'
    end
  end

  describe '詳細表示機能' do
    context 'タスクが存在する場合' do
      before do
        visit task_path(task_a)
      end

      it '各項目が表示される' do
        expect(page).to have_content 'タスク１'
        expect(page).to have_content 'タスク１を実施する'
      end
    end
  end

  describe '新規登録機能' do
    before do
      visit new_task_path
      fill_in 'Name', with: name
      fill_in 'Description', with: description
    end

    context 'タスクの内容を正しく入力した場合' do
      let(:name) { '新規作成テスト用タスク' }
      let(:description) { '新規作成テスト用タスクを実施する' }

      it 'タスクが正常に作成される' do
        # DBに登録されている
        expect { click_button 'Create Task' }.to change(Task, :count).by(1)
        # 画面で入力された内容でDBに登録されている
        task = Task.find_by(name: name)
        expect(task.name).to eq(name)
        expect(task.description).to eq(description)
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: "タスク「#{task.name}」を登録しました。"
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
      let(:name) { '新規作成テスト用タスク２' }
      let(:description) { '新規作成テスト用タスク２を実施する' }

      it 'タスクが正常に更新される' do
        # 画面表示時に編集前のタスク内容が各項目に表示されている
        expect(page).to have_field 'Name', with: task_a.name
        expect(page).to have_field 'Description', with: task_a.description
        # 更新処理
        fill_in 'Name', with: name
        fill_in 'Description', with: description
        click_button 'Update Task'
        # 画面で入力された内容でDBのデータが更新されている
        task = Task.find_by(name: name)
        expect(task.name).to eq(name)
        expect(task.description).to eq(description)
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: "タスク「#{task.name}」を更新しました。"
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
        expect(Task.find_by(name: task_a.name)).to be nil
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: "タスク「#{task_a.name}」を削除しました。"
      end
    end
  end

  describe 'ページ遷移' do
    context 'タスク一覧画面から詳細画面へ遷移' do
      before do
        visit tasks_path
        click_link '詳細', match: :first
      end
      it '詳細画面へ遷移できること' do
        expect(page).to have_current_path task_path(task_a)
      end
    end

    context '一覧画面から新規登録画面へ遷移' do
      before do
        visit tasks_path
        click_link '新規作成'
      end
      it '新規登録画面へ遷移できる' do
        expect(page).to have_current_path new_task_path
      end
    end

    context '新規登録画面からタスク一覧画面へ遷移' do
      before do
        visit new_task_path
        click_link '戻る'
      end
      it '一覧画面へ遷移できる' do
        expect(page).to have_current_path tasks_path
      end
    end

    context '詳細画面からタスク一覧画面へ遷移' do
      before do
        visit task_path(task_a)
        click_link '戻る'
      end
      it '一覧画面へ遷移できる' do
        expect(page).to have_current_path tasks_path
      end
    end

    context '詳細画面から編集画面へ遷移' do
      before do
        visit task_path(task_a)
        click_link '編集'
      end
      it '編集画面へ遷移できる' do
        expect(page).to have_current_path edit_task_path(task_a)
      end
    end

    context '編集画面から詳細画面へ遷移' do
      before do
        visit edit_task_path(task_a)
        click_link '詳細へ'
      end
      it '詳細画面へ遷移できる' do
        expect(page).to have_current_path task_path(task_a)
      end
    end
  end
end
