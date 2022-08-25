require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    subject(:visit_tasks) { visit tasks_path }

    describe '表示機能' do
      # タスクが表示される期待動作を共通化
      shared_examples_for 'タスク表示' do
        let(:tds){ all('tbody tr')[0].all('td') }

        context 'タスクが1件存在する場合' do
          it 'タスク名が表示される' do
            visit_tasks
            expect(tds[0]).to have_content task_1.title
          end
        end
      end

      shared_examples_for '２件目のタスク表示' do
        let(:tds){ all('tbody tr')[1].all('td') }

        context 'タスクが2件(複数)存在する場合' do
          it 'タスク名が表示される' do
            visit_tasks
            expect(tds[0]).to have_content task_2.title
          end
        end
      end
    end
  end

  describe '詳細表示機能' do
    user = User.create!(name: 'name1')
    let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', status: '1', label: '1', user_id: user[:id]) }
    subject(:visit_task_a) { visit task_path(task_a) }

    describe '表示機能' do
      context 'タスクが存在する場合' do
        it '各項目が表示される' do
          visit_task_a
          expect(page).to have_content '最初のタスク'
        end
      end
    end
  end

  describe '新規登録機能' do
    subject(:visit_new_task){ visit new_task_path }

    context 'タスクの各項目を登録した場合' do
      let(:title) { '新規作成のテスト２' }
      let(:description) { '新規作成のテストを書く２' }
      it 'タスクが正常に登録される' do
        visit_new_task
        # 登録処理
        fill_in 'textarea1', with: title
        fill_in 'textarea2', with: description
        click_button 'submit'
      end
    end
  end

  describe '編集機能' do
    user = User.create!(name: 'name1')
    let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', status: '1', label: '1', user_id: user[:id]) }
    subject(:visit_task_a_edit){visit edit_task_path(task_a)}

    context 'タスクの各項目を更新した場合' do
      let(:title) { '新規作成のテスト２' }
      let(:description) { '新規作成のテストを書く２' }
      it 'タスクが正常に更新される' do
        visit_task_a_edit
        # 更新処理
        fill_in 'textarea1', with: title
        fill_in 'textarea2', with: description

        click_button 'submit'
        # 画面で入力された内容でDBのデータが更新されている
        task = Task.find_by(title: title)
        expect(task.title).to eq(title)
        expect(task.description).to eq(description)
        # Flashメッセージが表示される
        expect(page).to have_selector '.alert-success', text: 'Update Task Success!!'
      end
    end
  end
end
