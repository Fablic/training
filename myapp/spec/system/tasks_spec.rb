require 'rails_helper'

describe 'タスク管理機能', type: :system do
  # タスクを作成
  let!(:task_a) {FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1)}
  let!(:task_b) {FactoryBot.create(:task, name: '２つ目のタスク', detail: '２つ目のタスクを実施する', status: 1, priority: 2)}
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
        expect(page).to have_content '未着手'
        expect(page).to have_content '低'
      end
    end 
  end

  describe '新規登録機能' do
    before do
        visit new_task_path
        fill_in 'タスク名', with: name
        fill_in '詳細', with: detail
        select(value = status, from: 'task[status]')
        select(value = priority, from: 'task[priority]')
    end

    context 'タスクの内容を入力した場合' do
      let(:name) { '新規作成のテスト' }
      let(:detail) { '新規作成のテストを書く' }
      let(:status) { '未着手' }
      let(:priority) { '低' }

      it 'タスクが正常に作成される' do
        # DBに登録されている
        expect{ click_button '登録' }.to change(Task, :count).by(1)
        # 画面で入力された内容でDBに登録されている
        task = Task.find_by(name: name)
        expect(task.name).to eq(name)
        expect(task.detail).to eq(detail)
        expect(task.status).to eq(status)
        expect(task.priority).to eq(priority)
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
        let(:name) { '新規作成のテスト２' }
        let(:detail) { '新規作成のテストを書く２' }
        let(:status) { '着手中' }
        let(:priority) { '中' }

      it 'タスクが正常に更新される' do
        # 画面表示時に編集前のタスク内容が各項目に表示されている
        expect(page).to have_field 'タスク名', with: task_a.name
        expect(page).to have_field '詳細', with: task_a.detail
        expect(page).to have_field 'ステータス', with: task_a.status
        expect(page).to have_field '優先度', with: task_a.priority
        # 更新処理
        fill_in 'タスク名', with: name
        fill_in '詳細', with: detail
        select(value = status, from: 'task[status]')
        select(value = priority, from: 'task[priority]')
        click_button '更新'
        # 画面で入力された内容でDBのデータが更新されている
        task = Task.find_by(name: name)
        expect(task.name).to eq(name)
        expect(task.detail).to eq(detail)
        expect(task.status).to eq(status)
        expect(task.priority).to eq(priority)
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: '新規作成のテスト２'
      end
    end
  end

  describe '削除機能', js: true do
    before do
      visit task_path(task_a)
    end

    context 'タスクを削除した場合' do   
      it 'タスクが正常に削除される' do
        # DBの該当データが削除される
        expect{ click_on('削除') }.to change(Task, :count).by(-1)
        expect(Task.find_by(name: task_a.name)).to be nil
        # TODO：質問する　######################
        # click_link '削除'
        # expect {
        #     page.accept_confirm 'タスク「最初のタスク」を削除します。よろしいですか？'
        #     expect(page).to have_content '削除しました'
        #   }.to change { Task.count }.by(-1)
        ######################################
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: '削除しました'
      end
    end

    # TODO：エラー解決後にコメントあると解除
    # context 'ダイアログでタスクの削除をキャンセルした場合' do
    #     it 'タスク詳細表示画面が表示される' do
    #       # DBの該当データが削除されていない
    #       expect{ click_on('キャンセル') }.to change(Task, :count).by(0)
    #       # 詳細表示画面が表示される
  
    #     end
    #   end
  end

  describe 'ページ遷移' do
    context 'タスク一覧画面から詳細画面へ遷移' do
      before do
        visit tasks_path
        click_link '詳細', match: :first
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
        click_link '一覧へ戻る'
      end
      it '一覧画面へ遷移できる' do
        expect(current_path).to eq tasks_path
      end
    end

    context '詳細画面からタスク一覧画面へ遷移' do
      before do
        visit task_path(task_a)
        click_link '一覧へ戻る'
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

    context '編集画面から詳細画面へ遷移' do
      before do
        visit edit_task_path(task_a)
        click_link '詳細へ戻る'
      end
      it '詳細画面へ遷移できる' do
        expect(current_path).to eq task_path(task_a)
      end
    end

    context '編集画面から一覧画面へ遷移' do
      before do
        visit edit_task_path(task_a)
        click_link '一覧へ戻る'
      end
      it '詳細画面へ遷移できる' do
        expect(current_path).to eq tasks_path
      end
    end
  end
end