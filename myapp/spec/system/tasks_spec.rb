require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    subject(:visit_tasks) { visit tasks_path }

    describe '表示機能'do
      # タスクが表示される期待動作を共通化
      shared_examples_for 'タスク表示' do
        let(:tds){ all('tbody tr')[0].all('td') }

        context '1件目のタスクの場合' do
          it 'タスク名が表示される' do
            visit_tasks
            expect(tds[0]).to have_content task_1.name
          end
          it 'ステータスが表示される' do
            visit_tasks
            expect(tds[1]).to have_content task_1.status
          end
          it '優先度が表示される' do
            visit_tasks
            expect(tds[2]).to have_content task_1.priority
          end
        end
      end
      shared_examples_for '２件目のタスク表示' do
        let(:tds){ all('tbody tr')[1].all('td') }

        context '2件目のタスクの場合' do
          it 'タスク名が表示される' do
            visit_tasks
            expect(tds[0]).to have_content task_2.name
          end
          it 'ステータスが表示される' do
            visit_tasks
            expect(tds[1]).to have_content task_2.status
          end
          it '優先度が表示される' do
            visit_tasks
            expect(tds[2]).to have_content task_2.priority
          end
        end
      end

      context 'タスクが1件存在する場合' do
        let!(:task_1) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }

        it_behaves_like 'タスク表示'
      end

      context 'タスクが2件(複数)存在する場合' do
        let!(:task_1) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }
        let!(:task_2) { FactoryBot.create(:task, name: '２つ目のタスク', detail: '２つ目のタスクを実施する', status: 1, priority: 2) }

        it_behaves_like 'タスク表示'
        it_behaves_like '２件目のタスク表示'
      end
    end

    describe '画面遷移機能' do
      let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }
      context '詳細ボタンをクリックした場合' do
        it '詳細画面へ遷移できる' do
          visit_tasks
          click_link '詳細', match: :first
          expect(page).to have_current_path task_path(task_a)
        end
      end

      context '新規登録ボタンをクリックした場合' do
        it '新規登録画面へ遷移できる' do
          visit_tasks
          click_link '新規登録'
          expect(page).to have_current_path new_task_path
        end
      end
    end
  end

  describe '詳細表示機能' do
    let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }
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

        it 'ステータスが表示される' do
          visit_task_a
          expect(page).to have_content 'not_started'
        end

        it '優先度が表示される' do
          visit_task_a
          expect(page).to have_content 'low'
        end
      end
    end

    describe '削除機能' do
      context '削除ボタンをクリックした場合' do
        it 'タスクが1件削除される' do
          visit_task_a
          expect { click_on('削除') }.to change(Task, :count).by(-1)
        end

        it '対象のタスクが無くなる' do
          visit_task_a
          click_on('削除')
          expect(Task.find_by(name: task_a.name)).to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a
          click_on('削除')
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: "タスク「#{task_a.name}」を削除しました。"
        end
      end
      # メモ：ダイアログでキャンセルを選択した場合のテスト（JS）については、エラーが発生し対応に時間がかかりそうなため省略。
    end

    describe '画面遷移機能' do
      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_task_a
          click_link '一覧へ戻る'
          expect(page).to have_current_path tasks_path
        end
      end

      context '編集ボタンをクリックした場合' do
        it '編集画面へ遷移できる' do
          visit_task_a
          click_link '編集'
          expect(page).to have_current_path edit_task_path(task_a)
        end
      end
    end
  end

  describe '新規登録機能' do
    subject(:visit_new_task){ visit new_task_path }

    describe '登録機能' do
      context 'タスクの内容を入力した場合' do
        let(:name) { '新規作成のテスト' }
        let(:detail) { '新規作成のテストを書く' }
        let(:status) { 'not_started' }
        let(:priority) { 'low' }

        it 'タスクの件数が1件増える' do
          # タスク内容入力
          visit_new_task
          fill_in 'タスク名', with: name
          fill_in '詳細', with: detail
          select(value = status, from: 'task[status]')
          select(value = priority, from: 'task[priority]')
          # DBに登録されている
          expect { click_button '登録' }.to change(Task, :count).by(1)
        end

        it '入力された内容でタスクが作成される' do
          # タスク内容入力
          visit_new_task
          fill_in 'タスク名', with: name
          fill_in '詳細', with: detail
          select(value = status, from: 'task[status]')
          select(value = priority, from: 'task[priority]')
          click_button '登録'
          # 画面で入力された内容でDBに登録されている
          expect(Task.find_by(name: name, detail: detail, status: status, priority: priority)).not_to be_nil
        end

        it 'Flashメッセージが表示される' do
          # タスク内容入力
          visit_new_task
          fill_in 'タスク名', with: name
          fill_in '詳細', with: detail
          select(value = status, from: 'task[status]')
          select(value = priority, from: 'task[priority]')
          # Flashメッセージが表示される
          click_button '登録'
          expect(page).to have_selector '.alert-success', text: "タスク「#{name}」を登録しました。"
        end

        it '一覧画面が表示される' do
          # タスク内容入力
          visit_new_task
          fill_in 'タスク名', with: name
          fill_in '詳細', with: detail
          select(value = status, from: 'task[status]')
          select(value = priority, from: 'task[priority]')

          visit_new_task
          click_button '登録'
          expect(page).to have_current_path tasks_path
        end
      end
    end

    describe '画面遷移機能' do
      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_new_task
          click_link '一覧へ戻る'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end

  describe '編集機能' do
    let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }
    subject(:visit_task_a_edit){visit edit_task_path(task_a)}

    describe '表示機能' do
      context '画面を表示した場合' do
        it '編集前のタスク名が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'タスク名', with: task_a.name
        end
        it '編集前の詳細が表示される' do
          visit_task_a_edit
          expect(page).to have_field '詳細', with: task_a.detail
        end
        it '編集前のステータスが表示される' do
          visit_task_a_edit
          expect(page).to have_field 'ステータス', with: task_a.status
        end
        it '編集前の優先度が表示される' do
          visit_task_a_edit
          expect(page).to have_field '優先度', with: task_a.priority
        end
      end
    end

    describe '更新機能' do
      context 'タスクの各項目を更新した場合' do
        let(:name) { '新規作成のテスト２' }
        let(:detail) { '新規作成のテストを書く２' }
        let(:status) { 'in_progress' }
        let(:priority) { 'middle' }

        it 'タスクが更新される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'タスク名', with: name
          fill_in '詳細', with: detail
          select(value = status, from: 'task[status]')
          select(value = priority, from: 'task[priority]')
          click_button '更新'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Task.find_by(name: name, detail: detail, status: status, priority: priority)).not_to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'タスク名', with: name
          fill_in '詳細', with: detail
          select(value = status, from: 'task[status]')
          select(value = priority, from: 'task[priority]')
          click_button '更新'
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: "タスク「#{name}」を更新しました。"
        end
      end
    end

    describe '画面遷移機能' do
      context '詳細へボタンをクリックした場合' do
        it '詳細画面へ遷移できる' do
          visit_task_a_edit
          click_link '詳細へ戻る'
          expect(page).to have_current_path task_path(task_a)
        end
      end

      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_task_a_edit
          click_link '一覧へ戻る'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end
end
