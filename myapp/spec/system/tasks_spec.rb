require 'rails_helper'

describe 'タスク管理機能', type: :system do
  # タスクを作成
  let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: "1", status: 0, label: '1') }
  let!(:task_b) { FactoryBot.create(:task, title: '２つ目のタスク', description: '２つ目のタスクを実施する', user_id: "1", status: 0, label: '2') }
  # タスクが表示される期待動作を共通化
  shared_examples_for 'タスクが表示される' do
    it { expect(page).to have_content '最初のタスク' }
  end
  shared_examples_for '２つ目のタスクが表示される' do
    it { expect(page).to have_content '２つ目のタスク' }
  end

  describe '一覧表示機能' do
    describe '表示機能'do
      # タスクが表示される期待動作を共通化
      shared_examples_for 'タスク表示' do
        subject(:visit_tasks) { visit tasks_path }
        subject(:tds){ all('tbody tr')[0].all('td') }
        context '1件目のタスクの場合' do
          it 'タスク名が表示される' do
            visit_tasks
            expect(tds[0]).to have_content task_1.title
          end
        end
      end
      shared_examples_for '２件目のタスク表示' do
        subject(:visit_tasks) { visit tasks_path }
        subject(:tds){ all('tbody tr')[1].all('td') }
        context '2件目のタスクの場合' do
          it 'タスク名が表示される' do
            visit_tasks
            expect(tds[0]).to have_content task_2.title
          end
        end
      end

      context 'タスクが1件存在する場合' do
        let!(:task_1) { task_a }

        it_behaves_like 'タスク表示'
      end

      context 'タスクが2件(複数)存在する場合' do
        let!(:task_1) { task_a }
        let!(:task_2) { task_b }

        it_behaves_like 'タスク表示'
        it_behaves_like '２件目のタスク表示'
      end
    end

    describe '画面遷移機能' do
      context '詳細ボタンをクリックした場合' do
        let!(:task_1) { task_a }

        it '詳細画面へ遷移できる' do
          visit tasks_path
          click_link '詳細リンク', match: :first
          expect(page).to have_current_path task_path(task_a)
        end
      end

      context '新規登録ボタンをクリックした場合' do
        it '新規登録画面へ遷移できる' do
          visit tasks_path
          click_link '新規登録'
          expect(page).to have_current_path new_task_path
        end
      end
    end
  end

  describe '詳細表示機能' do
    subject(:visit_task_a) { visit task_path(task_a) }

    describe '表示機能' do
      context 'タスクが存在する場合' do
        it 'タスク名が表示される' do
          visit_task_a
          expect(page).to have_content '最初のタスク'
        end

        it '詳細が表示される' do
          visit_task_a
          expect(page).to have_content '最初のタスクを実施する'
        end
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
