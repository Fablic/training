require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    subject(:visit_tasks){ visit tasks_path }

    describe '表示機能' do
      shared_examples_for '１つ目のタスクが表示される' do
        it {
          visit tasks_path
          expect(page).to have_content 'タスク１'
        }
      end
      shared_examples_for '２つ目のタスクが表示される' do
        it {
          visit tasks_path
          expect(page).to have_content 'タスク２'
        }
      end

      context 'タスクが1件存在する場合' do
        let!(:task_a) { FactoryBot.create(:task, name: 'タスク１', description: 'タスク１を実施する') }

        it_behaves_like '１つ目のタスクが表示される'
      end

      context 'タスクが2件存在する場合' do
        let!(:task_a) { FactoryBot.create(:task, name: 'タスク１', description: 'タスク１を実施する') }
        let!(:task_b) { FactoryBot.create(:task, name: 'タスク２', description: 'タスク２を実施する') }

        it_behaves_like '１つ目のタスクが表示される'
        it_behaves_like '２つ目のタスクが表示される'
      end
    end

    describe '遷移機能' do
      let!(:task_a) { FactoryBot.create(:task, name: 'タスク１', description: 'タスク１を実施する') }

      context 'タスク一覧画面から詳細画面へ遷移' do
        it '詳細画面へ遷移できる' do
          visit_tasks
          click_link '詳細', match: :first
          expect(page).to have_current_path task_path(task_a)
        end
      end

      context '一覧画面から新規登録画面へ遷移' do
        it '新規登録画面へ遷移できる' do
          visit_tasks
          click_link '新規作成'
          expect(page).to have_current_path new_task_path
        end
      end
    end
  end

  describe '詳細表示機能' do
    let!(:task_a) { FactoryBot.create(:task, name: 'タスク１', description: 'タスク１を実施する') }
    subject(:visit_task_a){ visit task_path(task_a) }

    describe '表示機能' do
      context 'タスクが存在する場合' do
        it 'タスク名が表示される' do
          visit_task_a
          expect(page).to have_content 'タスク１'
        end

        it '詳細が表示される' do
          visit_task_a
          expect(page).to have_content 'タスク１を実施する'
        end
      end
    end

    describe '遷移機能' do

      context '詳細画面からタスク一覧画面へ遷移' do
        it '一覧画面へ遷移できる' do
          visit_task_a
          click_link '戻る'
          expect(page).to have_current_path tasks_path
        end
      end

      context '詳細画面から編集画面へ遷移' do
        it '編集画面へ遷移できる' do
          visit_task_a
          click_link '編集'
          expect(page).to have_current_path edit_task_path(task_a)
        end
      end
    end
  end

  describe '新規登録機能' do
    describe '登録機能' do
      context 'タスクの内容を入力した場合' do
        let(:name) { '新規作成テスト用タスク' }
        let(:description) { '新規作成テスト用タスクを実施する' }
        subject(:visit_new_task){ visit new_task_path }

        it 'タスクが作成される' do
          visit_new_task
          fill_in 'Name', with: name
          fill_in 'Description', with: description
          # DBに登録されている
          click_button 'Create Task'
          # 画面で入力された内容でDBに登録されている
          expect(Task.find_by(name: name, description: description)).not_to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_new_task
          fill_in 'Name', with: name
          fill_in 'Description', with: description
          click_button 'Create Task'
          expect(page).to have_selector '.alert-success', text: "タスク「#{name}」を登録しました。"
        end

        it 'タスク一覧画面が表示される' do
          visit_new_task
          fill_in 'Name', with: name
          fill_in 'Description', with: description
          click_button 'Create Task'
          expect(current_path).to eq tasks_path
        end
      end
    end

    describe '遷移機能' do
      context '新規登録画面からタスク一覧画面へ遷移' do
        it '一覧画面へ遷移できる' do
          visit new_task_path
          click_link '戻る'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end

  describe '編集機能' do
    let!(:task_a) { FactoryBot.create(:task, name: 'タスク１', description: 'タスク１を実施する') }
    subject(:visit_task_a_edit){ visit edit_task_path(task_a) }

    describe '表示機能' do
      context '画面を表示した場合' do
        it '編集前にタスク名が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'Name', with: task_a.name
        end

        it '編集前に詳細が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'Description', with: task_a.description
        end
      end
    end

    describe '更新機能' do
      context 'タスクの各項目を更新した場合' do
        let(:name) { '新規作成テスト用タスク２' }
        let(:description) { '新規作成テスト用タスク２を実施する' }

        it 'タスクが更新される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'Name', with: name
          fill_in 'Description', with: description
          click_button 'Update Task'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Task.find_by(name: name, description: description)).not_to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'Name', with: name
          fill_in 'Description', with: description
          click_button 'Update Task'
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: "タスク「#{name}」を更新しました。"
        end
      end
    end

    describe '遷移機能' do

      context '編集画面から詳細画面へ遷移' do
        it '詳細画面へ遷移できる' do
          visit_task_a_edit
          click_link '詳細へ'
          expect(page).to have_current_path task_path(task_a)
        end
      end
    end
  end

  describe '削除機能' do
    let!(:task_a) { FactoryBot.create(:task, name: 'タスク１', description: 'タスク１を実施する') }

    context 'タスクを削除した場合' do
      subject(:visit_task_a){ visit task_path(task_a) }
      it 'データが1件のみ減っている' do
        visit_task_a
        # DBの該当データが削除される
        expect { click_on('削除') }.to change(Task, :count).by(-1)
      end

      it '該当タスクが削除される' do
        visit_task_a
        click_on('削除')
        # DBの該当データが削除される
        expect(Task.find_by(name: task_a.name)).to be nil
      end

      it 'Flashメッセージが表示される' do
        visit_task_a
        click_on('削除')
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: "タスク「#{task_a.name}」を削除しました。"
      end
    end
  end
end
