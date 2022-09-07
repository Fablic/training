require 'rails_helper'

describe 'タスク管理機能', type: :system do

  describe '一覧表示機能' do
    subject(:visit_tasks) { visit tasks_path }

    describe '表示機能' do
      # タスクが表示される期待動作を共通化

      context 'タスクが1件存在する場合' do
        let!(:task_1) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: '1', status: '1', label: '1') }

        let(:tds){ all('tbody tr')[0].all('td') }
        it 'タスク名が表示される' do
          visit_tasks
          expect(tds[0]).to have_content '最初のタスク'
        end

        it 'ラベルが表示される' do
          visit_tasks
          expect(tds[1]).to have_content '1'
        end
      end

      context 'タスクが2件(複数)存在する場合' do
        let!(:task_1) { FactoryBot.create(:task, title: '0 title', description: '最初のタスクを実施する', user_id: '1', status: '1', label: '0 label') }
        let!(:task_2) { FactoryBot.create(:task, title: '1 title', description: '２つ目のタスクを実施する', user_id: '1', status: '1', label: '1 label') }

        let(:tds){ all('tbody tr')[1].all('td') }
        it 'タスク名が表示される' do
          visit_tasks
          expect(tds[0]).to have_content '1 title'
        end

        it 'ラベルが表示される' do
          visit_tasks
          expect(tds[1]).to have_content '1 label'
        end
      end

      describe '画面遷移機能' do
        let!(:task_a) { FactoryBot.create(:task, title: '0 title', description: '最初のタスクを実施する', user_id: '1', status: '1', label: '0 label') }
        context '詳細ボタンをクリックした場合' do
          it '詳細画面へ遷移できる' do
            visit_tasks
            click_link I18n.t('button.detail'), match: :first
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

        context '編集ボタンをクリックした場合' do
          it '編集画面へ遷移できる' do
            visit_tasks
            click_link I18n.t('button.update'), match: :first
            expect(page).to have_current_path edit_task_path(task_a)
          end
        end
      end
    end
  end

  describe '詳細表示機能' do
    let!(:task_a) { FactoryBot.create(:task, title: '0 title', description: '最初のタスクを実施する', user_id: '1', status: '1', label: '0 label') }
    subject(:visit_task_a) { visit task_path(task_a) }

    describe '表示機能' do
      context 'タスクが存在する場合' do
        it 'タスク名が表示される' do
          visit_task_a
          expect(page).to have_content '0 title'
        end

        it '詳細が表示される' do
          visit_task_a
          expect(page).to have_content '最初のタスクを実施する'
        end

        it 'ラベルが表示される' do
          visit_task_a
          expect(page).to have_content '0 label'
        end
      end
    end

    describe '画面遷移機能' do
      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_task_a
          click_link '一覧に戻る'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end

  describe '新規登録機能' do
    subject(:visit_new_task){ visit new_task_path }

    context 'タスクの各項目を登録した場合' do
      let(:input_values) {
        {
          title: '新規作成のテスト2',
          description: '新規作成のテストを書く2',
          user_id: '1',
        }
      }

      it 'タスクが正常に登録される' do
        visit_new_task
        # 登録処理
        fill_in 'textarea1', with: '新規作成のテスト2'
        fill_in 'textarea2', with: '新規作成のテストを書く2'
        expect { click_button 'submit' }.to change(Task, :count).by(1)
      end
    end

    describe '画面遷移機能' do
      let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: '1', status: '1', label: '1') }

      context '新規登録ボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_new_task
          click_button 'submit'
          expect(page).to have_current_path tasks_path
        end
      end

      context '一覧へボタンをクリックした場合' do
        it '一覧画面へ遷移できる' do
          visit_new_task
          click_link '一覧に戻る'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end

  describe '編集機能' do
    let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: '1', status: '1', label: '1') }
    subject(:visit_task_a_edit){visit edit_task_path(task_a)}

    describe '表示機能' do
      context '画面を表示した場合' do
        it '編集前のタスク名が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'textarea1', with: '最初のタスク'
        end
        it '編集前の詳細が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'textarea2', with: '最初のタスクを実施する'
        end
      end
      context 'タスクの各項目を更新した場合' do
        let(:input_values) {
          {
            title: '最初のタスク',
            description: '最初のタスクを実施する',
            user_id: '1',
          }
        }

        it 'タスクが正常に更新される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'textarea1', with: '最初のタスク'
          fill_in 'textarea2', with: '最初のタスクを実施する'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Task.find_by(input_values)).to be_present
        end
      end

      describe '画面遷移機能' do
        context '一覧へボタンをクリックした場合' do
          it '一覧画面へ遷移できる' do
            visit_task_a_edit
            click_link '一覧に戻る'
            expect(page).to have_current_path tasks_path
          end
        end
      end
    end
  end
end
