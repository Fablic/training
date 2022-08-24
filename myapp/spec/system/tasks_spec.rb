require 'rails_helper'

describe 'タスク管理機能', type: :system do
  # タスクを作成
  let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: "1", status: 0, label: '1') }
  let!(:task_b) { FactoryBot.create(:task, title: '２つ目のタスク', description: '２つ目のタスクを実施する', user_id: "1", status: 0, label: '2') }

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

    describe '削除機能' do
      subject(:visit_task_a) { visit task_path(task_a) }
      context '削除ボタンをクリックした場合' do
        it 'タスクが正常に削除される' do
          visit_task_a
          # DBの該当データが削除される
          expect { click_on('削除') }.to change(Task, :count).by(-1)
          expect(Task.find_by(title: task_a.title)).to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a
          click_on('削除')
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: "タスク「#{task_a.title}」を削除しました。"
        end
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

    describe '削除機能' do
      context '削除ボタンをクリックした場合' do
        it 'タスクが正常に削除される' do
          visit_task_a
          # DBの該当データが削除される
          expect { click_on('削除') }.to change(Task, :count).by(-1)
          expect(Task.find_by(title: task_a.title)).to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a
          click_on('削除')
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: "タスク「#{task_a.title}」を削除しました。"
        end
      end
    end
  end

  describe '新規登録機能' do
    subject(:visit_new_task){ visit new_task_path }

    describe '登録機能' do
      context 'タスクの内容を入力した場合' do
        let(:name) { '新規作成のテスト' }
        let(:description) { '新規作成のテストを書く' }
        let(:status) { 'not_started' }
        let(:label) { 'low' }

        it 'タスクが正常に作成される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: title
          fill_in 'textarea2', with: description
          # DBに登録されている
          expect { click_button 'submit' }.to change(Task, :count).by(1)
          # 画面で入力された内容でDBに登録されている
          expect(Task.find_by(title: title, description: description)).not_to be_nil
        end

        it 'Flashメッセージが表示される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: title
          fill_in 'textarea2', with: description

          visit_new_task
          click_button 'submit'
          expect(page).to have_selector '.alert-success', text: "タスク「#{title}」を登録しました。"
        end

        it '一覧画面が表示される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: title
          fill_in 'textarea2', with: description

          visit_new_task
          click_button 'submit'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end

  describe '編集機能' do
    subject(:visit_task_a_edit){visit edit_task_path(task_a)}

    describe '表示機能' do
      context '画面を表示した場合' do
        it '編集前のタスク名が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'textarea1', with: task_a.title
        end
        it '編集前の詳細が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'textarea2', with: task_a.description
        end
      end
    end

    describe '更新機能' do
      context 'タスクの各項目を更新した場合' do
        let(:title) { '新規作成のテスト２' }
        let(:description) { '新規作成のテストを書く２' }
        let(:status) { 'in_progress' }
        let(:label) { 'middle' }

        it 'タスクが更新される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'textarea1', with: title
          fill_in 'textarea2', with: description
          click_button 'submit'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Task.find_by(title: title, description: description)).not_to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'textarea1', with: title
          fill_in 'textarea2', with: description
          click_button 'submit'
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: "タスク「#{title}」を更新しました。"
        end
      end
    end
  end
end
