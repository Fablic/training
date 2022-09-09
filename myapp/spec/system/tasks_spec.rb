require 'rails_helper'

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    subject(:visit_tasks) { visit tasks_path }

    describe '表示機能'do
      context 'ログインしている場合' do
        # タスクが表示される期待動作を共通化
        shared_examples_for 'タスク表示' do
          let(:tds){ all('tbody tr')[0].all('td') }

          context '1件目のタスクの場合' do
            it 'タスク名が表示される' do
              visit_tasks
              expect(tds[0]).to have_content '最初のタスク'
            end
            it 'ステータスが表示される' do
              visit_tasks
              expect(tds[1]).to have_content '未着手'
            end
            it '優先度が表示される' do
              visit_tasks
              expect(tds[2]).to have_content '低'
            end
            it 'ラベルが表示される' do
              visit_tasks
              expect(tds[3]).to have_content 'testLabel'
            end
          end
        end
        shared_examples_for '２件目のタスク表示' do
          let(:tds){ all('tbody tr')[1].all('td') }

          context '2件目のタスクの場合' do
            it 'タスク名が表示される' do
              visit_tasks
              expect(tds[0]).to have_content '２つ目のタスク'
            end
            it 'ステータスが表示される' do
              visit_tasks
              expect(tds[1]).to have_content '未着手'
            end
            it '優先度が表示される' do
              visit_tasks
              expect(tds[2]).to have_content '中'
            end
            it 'ラベルが表示される' do
              visit_tasks
              expect(tds[3]).to have_content 'testLabel'
            end
          end
        end

        context 'タスクが1件存在する場合' do
          context 'ラベルが1件存在する場合' do
            let!(:task_1) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }
            let!(:label_a) { FactoryBot.create(:label) }
            let!(:labelling) { FactoryBot.create(:labelling, task: task_1, label: label_a) }

            before do
              visit login_path
              fill_in 'session[email]', with: 'testUser@example.com'
              fill_in 'session[password]', with: 'testPassword'
              click_button 'ログイン'
            end

            it_behaves_like 'タスク表示'
          end

          context 'ラベルが複数(2件)存在する場合' do
            let!(:task_1) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }
            let!(:label_a) { FactoryBot.create(:label) }
            let!(:labelling) { FactoryBot.create(:labelling, task: task_1, label: label_a) }
            let!(:label_b) { FactoryBot.create(:label, label_name: 'testLabel2') }
            let!(:labelling) { FactoryBot.create(:labelling, task: task_1, label: label_b) }
            let(:tds){ all('tbody tr')[0].all('td') }

            before do
              visit login_path
              fill_in 'session[email]', with: 'testUser@example.com'
              fill_in 'session[password]', with: 'testPassword'
              click_button 'ログイン'
            end

            it '1つ目のラベルが表示される' do
              visit_tasks
              expect(tds[3]).to have_content 'testLabel'
            end

            it '2つ目のラベルが表示される' do
              visit_tasks
              expect(tds[3]).to have_content 'testLabel2'
            end
          end

          context 'ラベルが存在しない場合' do
            let!(:task_1) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }
            let(:tds){ all('tbody tr')[0].all('td') }

            before do
              visit login_path
              fill_in 'session[email]', with: 'testUser@example.com'
              fill_in 'session[password]', with: 'testPassword'
              click_button 'ログイン'
            end

            it 'ラベルが表示されない' do
              visit_tasks
              expect(page).not_to have_content 'testLabel'
            end
          end
        end

        context 'タスクが2件(複数)存在する場合' do
          let!(:user_a) { FactoryBot.create(:user) }
          let!(:task_1) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_a) }
          let!(:task_2) { FactoryBot.create(:task, name: '２つ目のタスク', detail: '２つ目のタスクを実施する', status: 1, priority: 2, user: user_a) }
          let!(:label_a) { FactoryBot.create(:label) }
          let!(:labelling_a) { FactoryBot.create(:labelling, task: task_1, label: label_a) }
          let!(:labelling_b) { FactoryBot.create(:labelling, task: task_2, label: label_a) }

          before do
            visit login_path
            fill_in 'session[email]', with: 'testUser@example.com'
            fill_in 'session[password]', with: 'testPassword'
            click_button 'ログイン'
          end

          it_behaves_like 'タスク表示'
          it_behaves_like '２件目のタスク表示'
        end

        context 'タスクが存在しない場合' do
          let!(:user_a) { FactoryBot.create(:user) }

          before do
            visit login_path
            fill_in 'session[email]', with: 'testUser@example.com'
            fill_in 'session[password]', with: 'testPassword'
            click_button 'ログイン'
          end

          it 'タスクが表示されない' do
            visit_tasks
            expect(page).not_to have_content '最初のタスク'
          end
        end

        context 'ログイン者が担当するタスクではない場合' do
          let!(:user_b) { FactoryBot.create(:user, user_name: 'testUser2', email: 'testUser2@example.com', password: 'testPassword2') }
          let!(:task_1) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_b) }

          it 'タスクが表示されない' do
            visit_tasks
            expect(page).not_to have_content '最初のタスク'
          end
        end
      end

      context 'ログインしていない場合' do
        it 'ログイン画面が表示されること' do
          visit_tasks
          expect(page).to have_current_path login_path
        end
      end
    end

    describe '検索機能' do
      # タスクが表示される期待動作を共通化
      shared_examples_for 'タスク表示' do
        let(:tds){ all('tbody tr')[0].all('td') }

        context '1件目のタスクの場合' do
          it 'タスク名が表示される' do
            visit_tasks
            fill_in 'name', with: name
            select(value = status, from: 'status')
            select(value = label, from: 'label_id')
            click_button '検索'
            expect(tds[0]).to have_content '最初のタスク'
          end
          it 'ステータスが表示される' do
            visit_tasks
            fill_in 'name', with: name
            select(value = status, from: 'status')
            select(value = label, from: 'label_id')
            click_button '検索'
            expect(tds[1]).to have_content '未着手'
          end
          it '優先度が表示される' do
            visit_tasks
            fill_in 'name', with: name
            select(value = status, from: 'status')
            select(value = label, from: 'label_id')
            click_button '検索'
            expect(tds[2]).to have_content '低'
          end
          it 'ラベルが表示される' do
            visit_tasks
            fill_in 'name', with: name
            select(value = status, from: 'status')
            select(value = label, from: 'label_id')
            click_button '検索'
            expect(tds[3]).to have_content 'testLabel'
          end
        end
      end
      shared_examples_for '２件目のタスク表示' do
        let(:tds){ all('tbody tr')[1].all('td') }

        context '2件目のタスクの場合' do
          it 'タスク名が表示される' do
            visit_tasks
            fill_in 'name', with: name
            select(value = status, from: 'status')
            select(value = label, from: 'label_id')
            click_button '検索'
            expect(tds[0]).to have_content '２つ目のタスク'
          end
          it 'ステータスが表示される' do
            visit_tasks
            fill_in 'name', with: name
            select(value = status, from: 'status')
            select(value = label, from: 'label_id')
            click_button '検索'
            expect(tds[1]).to have_content '未着手'
          end
          it '優先度が表示される' do
            visit_tasks
            fill_in 'name', with: name
            select(value = status, from: 'status')
            select(value = label, from: 'label_id')
            click_button '検索'
            expect(tds[2]).to have_content '中'
          end
          it 'ラベルが表示される' do
            visit_tasks
            fill_in 'name', with: name
            select(value = status, from: 'status')
            select(value = label, from: 'label_id')
            click_button '検索'
            expect(tds[3]).to have_content 'testLabel'
          end
        end
      end

      context '検索条件に一致するタスクが1件存在する場合' do
        let!(:user_a) { FactoryBot.create(:user) }
        let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_a) }
        let!(:task_b) { FactoryBot.create(:task, name: '２つ目のタスク', detail: '２つ目のタスクを実施する', status: 1, priority: 2, user: user_a) }
        let!(:label_a) { FactoryBot.create(:label) }
        let!(:label_b) { FactoryBot.create(:label, label_name: 'testLabel2') }
        let!(:labelling_a) { FactoryBot.create(:labelling, task: task_a, label: label_a) }
        let!(:labelling_b) { FactoryBot.create(:labelling, task: task_b, label: label_b) }
        let(:name) { '最初のタスク' }
        let(:status) { '未着手' }
        let(:label) { 'testLabel' }

        before do
          visit login_path
          fill_in 'session[email]', with: 'testUser@example.com'
          fill_in 'session[password]', with: 'testPassword'
          click_button 'ログイン'
        end

        it_behaves_like 'タスク表示'
      end

      context '検索条件に一致するタスクが2件存在する場合' do
        let!(:user_a) { FactoryBot.create(:user) }
        let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_a) }
        let!(:task_b) { FactoryBot.create(:task, name: '２つ目のタスク', detail: '２つ目のタスクを実施する', status: 1, priority: 2, user: user_a) }
        let!(:label_a) { FactoryBot.create(:label) }
        let!(:label_b) { FactoryBot.create(:label, label_name: 'testLabel2') }
        let!(:labelling_a) { FactoryBot.create(:labelling, task: task_a, label: label_a) }
        let!(:labelling_b) { FactoryBot.create(:labelling, task: task_b, label: label_a) }
        let(:name) { 'タスク' }
        let(:status) { '未着手' }
        let(:label) { 'testLabel' }

        before do
          visit login_path
          fill_in 'session[email]', with: 'testUser@example.com'
          fill_in 'session[password]', with: 'testPassword'
          click_button 'ログイン'
        end

        it_behaves_like 'タスク表示'
        it_behaves_like '２件目のタスク表示'
      end

      context '検索条件に一致するタスクが存在しない場合' do
        let!(:user_a) { FactoryBot.create(:user) }
        let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_a) }
        let!(:task_b) { FactoryBot.create(:task, name: '２つ目のタスク', detail: '２つ目のタスクを実施する', status: 1, priority: 2, user: user_a) }
        let!(:label_a) { FactoryBot.create(:label) }
        let!(:label_b) { FactoryBot.create(:label, label_name: 'testLabel2') }
        let!(:labelling_a) { FactoryBot.create(:labelling, task: task_a, label: label_a) }
        let(:name) { 'テスト' }
        let(:status) { '完了' }
        let(:label) { 'testLabel2' }

        before do
          visit login_path
          fill_in 'session[email]', with: 'testUser@example.com'
          fill_in 'session[password]', with: 'testPassword'
          click_button 'ログイン'
        end

        it 'タスクが表示されない' do
          visit_tasks
          fill_in 'name', with: name
          select(value = status, from: 'status')
          select(value = label, from: 'label_id')
          click_button '検索'
          expect(page).not_to have_content 'のタスク'
        end
      end

      context '検索条件なしの場合' do
        let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }
        let!(:label_a) { FactoryBot.create(:label) }
        let!(:labelling_a) { FactoryBot.create(:labelling, task: task_a, label: label_a) }

        before do
          visit login_path
          fill_in 'session[email]', with: 'testUser@example.com'
          fill_in 'session[password]', with: 'testPassword'
          click_button 'ログイン'
        end

        it 'タスクが表示される' do
          visit_tasks
          click_button '検索'
          expect(page).to have_content '最初のタスク'
        end
      end

      context '検索結果に一致するタスクがログイン者が担当するタスクではない場合' do
        let!(:user_a) { FactoryBot.create(:user) }
        let!(:user_b) { FactoryBot.create(:user, user_name: 'testUser2', email: 'testUser2@example.com', password: 'testPassword2') }
        let!(:task_1) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_b) }
        let!(:label_a) { FactoryBot.create(:label) }
        let!(:labelling_a) { FactoryBot.create(:labelling, task: task_1, label: label_a) }
        let(:name) { 'タスク' }
        let(:status) { '未着手' }
        let(:label) { 'testLabel' }

        before do
          visit login_path
          fill_in 'session[email]', with: 'testUser@example.com'
          fill_in 'session[password]', with: 'testPassword'
          click_button 'ログイン'
        end

        it 'タスクが表示されない' do
          visit_tasks
          fill_in 'name', with: name
          select(value = status, from: 'status')
          select(value = label, from: 'label_id')
          click_button '検索'
          expect(page).not_to have_content '最初のタスク'
        end
      end
    end

    describe 'ログアウト機能' do
      let!(:user_a) { FactoryBot.create(:user) }

      before do
        visit login_path
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
      end

      context 'ログアウトした場合' do
        it 'ログイン画面が表示される' do
          visit_tasks
          click_link 'ログアウト'
          expect(page).to have_content 'ログイン画面'
        end
      end
    end

    describe '画面遷移機能' do
      let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1) }

      before do
        visit login_path
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
      end

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
    let!(:user_a) { FactoryBot.create(:user) }
    let!(:task_a) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_a) }
    subject(:visit_task_a) { visit task_path(task_a) }

    describe '表示機能' do
      context 'ログインしている場合' do
        before do
          visit login_path
          fill_in 'session[email]', with: 'testUser@example.com'
          fill_in 'session[password]', with: 'testPassword'
          click_button 'ログイン'
        end

        context 'タスクが存在する場合' do
          context 'ラベルが1件の場合' do
            let!(:label_a) { FactoryBot.create(:label) }
            let!(:labelling) { FactoryBot.create(:labelling, task: task_a, label: label_a) }

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
              expect(page).to have_content '未着手'
            end

            it '優先度が表示される' do
              visit_task_a
              expect(page).to have_content '低'
            end

            it 'ラベルが表示される' do
              visit_task_a
              expect(page).to have_content 'testLabel'
            end
          end

          context 'ラベルが複数(2件)の場合' do
            let!(:label_a) { FactoryBot.create(:label) }
            let!(:label_b) { FactoryBot.create(:label, label_name: 'testLabel2') }
            let!(:labelling_a) { FactoryBot.create(:labelling, task: task_a, label: label_a) }
            let!(:labelling_b) { FactoryBot.create(:labelling, task: task_a, label: label_b) }

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
              expect(page).to have_content '未着手'
            end

            it '優先度が表示される' do
              visit_task_a
              expect(page).to have_content '低'
            end

            it '1つ目のラベルが表示される' do
              visit_task_a
              expect(page).to have_content 'testLabel'
            end

            it '2つ目のラベルが表示される' do
              visit_task_a
              expect(page).to have_content 'testLabel2'
            end
          end

          context 'ラベルが設定されていない場合' do
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
              expect(page).to have_content '未着手'
            end

            it '優先度が表示される' do
              visit_task_a
              expect(page).to have_content '低'
            end

            it 'ラベルが表示されない' do
              visit_task_a
              expect(page).not_to have_content 'testLabel'
            end
          end

            it 'ラベルが表示される' do
              visit_task_a
              expect(page).to have_content 'testLabel'
            end
          end

          context 'ラベルが複数(2件)の場合' do
            let!(:label_a) { FactoryBot.create(:label) }
            let!(:label_b) { FactoryBot.create(:label, label_name: 'testLabel2') }
            let!(:labelling_a) { FactoryBot.create(:labelling, task: task_a, label: label_a) }
            let!(:labelling_b) { FactoryBot.create(:labelling, task: task_a, label: label_b) }

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
              expect(page).to have_content '未着手'
            end

            it '優先度が表示される' do
              visit_task_a
              expect(page).to have_content '低'
            end

            it '1つ目のラベルが表示される' do
              visit_task_a
              expect(page).to have_content 'testLabel'
            end

            it '2つ目のラベルが表示される' do
              visit_task_a
              expect(page).to have_content 'testLabel2'
            end
          end

          context 'ラベルが設定されていない場合' do
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
              expect(page).to have_content '未着手'
            end

            it '優先度が表示される' do
              visit_task_a
              expect(page).to have_content '低'
            end

            it 'ラベルが表示されない' do
              visit_task_a
              expect(page).not_to have_content 'testLabel'
            end
          end
        end

        context 'ログイン者のタスクではない場合' do
          let!(:user_b) { FactoryBot.create(:user, user_name: 'testUser2', email: 'testUser2@example.com', password: 'testPassword2') }
          let!(:task_b) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_b) }

          it 'エラー画面(404)が表示されること' do
            visit task_path(task_b)
            expect(page).to have_content '404'
          end
        end
      end

      context 'ログインしていない場合' do
        it 'ログイン画面が表示されること' do
          visit_task_a
          expect(page).to have_current_path login_path
        end
      end
    end

    describe '削除機能' do
      before do
        visit login_path
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
      end

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
          expect(page).to have_selector '.alert-success', text: 'タスク「最初のタスク」を削除しました。'
        end
      end
      # メモ：ダイアログでキャンセルを選択した場合のテスト（JS）については、エラーが発生し対応に時間がかかりそうなため省略。
    end

    describe '画面遷移機能' do
      before do
        visit login_path
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
      end

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
    let!(:user_a) { FactoryBot.create(:user) }
    let!(:label_a) { FactoryBot.create(:label) }
    let!(:label_b) { FactoryBot.create(:label, label_name: 'testLabel2') }
    subject(:visit_new_task){ visit new_task_path }

    describe '登録機能' do
      context 'ログインしている場合' do
        before do
          visit login_path
          fill_in 'session[email]', with: 'testUser@example.com'
          fill_in 'session[password]', with: 'testPassword'
          click_button 'ログイン'
        end

        context 'タスクの内容を入力した場合' do
          let(:name) { '新規作成のテスト' }
          let(:detail) { '新規作成のテストを書く' }
          let(:status) { '未着手' }
          let(:priority) { '低' }

          context 'ラベルが1件の場合' do
            it 'タスクの件数が1件増える' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              page.check 'testLabel'
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
              page.check 'testLabel'
              click_button '登録'
              # 画面で入力された内容でDBに登録されている
              expect(Task.eager_load(:labellings).where(name: '新規作成のテスト', detail: '新規作成のテストを書く', status: 'not_started', priority: 'low',
                user_id: user_a.id, label_id: label_a.id)).not_to be_nil
            end

            it 'Flashメッセージが表示される' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              page.check 'testLabel'
              # Flashメッセージが表示される
              click_button '登録'
              expect(page).to have_selector '.alert-success', text: 'タスク「新規作成のテスト」を登録しました。'
            end

            it '一覧画面が表示される' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              page.check 'testLabel'
              click_button '登録'
              expect(page).to have_current_path tasks_path
            end
          end

          context 'ラベルが複数（2件）の場合' do
            it 'タスクの件数が1件増える' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              page.check 'testLabel'
              page.check 'testLabel2'
              # DBに登録されている
              expect { click_button '登録' }.to change(Task, :count).by(1)
            end

            it '入力された内容でタスクが作成される(ラベル検索条件：１つ目のラベル)' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              page.check 'testLabel'
              page.check 'testLabel2'
              click_button '登録'
              # 画面で入力された内容でDBに登録されている
              expect(Task.eager_load(:labellings).where(name: '新規作成のテスト', detail: '新規作成のテストを書く', status: 'not_started', priority: 'low',
                user_id: user_a.id, label_id: label_a.id)).not_to be_nil
            end

            it '入力された内容でタスクが作成される(ラベル検索条件：２つ目のラベル)' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              page.check 'testLabel'
              page.check 'testLabel2'
              click_button '登録'
              # 画面で入力された内容でDBに登録されている
              expect(Task.eager_load(:labellings).where(name: '新規作成のテスト', detail: '新規作成のテストを書く', status: 'not_started', priority: 'low',
                user_id: user_a.id, label_id: label_b.id)).not_to be_nil
            end

            it 'Flashメッセージが表示される' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              page.check 'testLabel'
              page.check 'testLabel2'
              # Flashメッセージが表示される
              click_button '登録'
              expect(page).to have_selector '.alert-success', text: 'タスク「新規作成のテスト」を登録しました。'
            end

            it '一覧画面が表示される' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              page.check 'testLabel'
              page.check 'testLabel2'
              click_button '登録'
              expect(page).to have_current_path tasks_path
            end
          end

          context 'ラベルなしの場合' do
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
              expect(Task.find_by(name: '新規作成のテスト', detail: '新規作成のテストを書く', status: 'not_started', priority: 'low')).not_to be_nil
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
              expect(page).to have_selector '.alert-success', text: 'タスク「新規作成のテスト」を登録しました。'
            end

            it '一覧画面が表示される' do
              # タスク内容入力
              visit_new_task
              fill_in 'タスク名', with: name
              fill_in '詳細', with: detail
              select(value = status, from: 'task[status]')
              select(value = priority, from: 'task[priority]')
              click_button '登録'
              expect(page).to have_current_path tasks_path
            end
          end
        end
      end

      context 'ログインしていない場合' do
        it 'ログイン画面が表示されること' do
          visit_new_task
          expect(page).to have_current_path login_path
        end
      end
    end

    describe '画面遷移機能' do
      before do
        visit login_path
        fill_in 'session[email]', with: 'testUser@example.com'
        fill_in 'session[password]', with: 'testPassword'
        click_button 'ログイン'
      end

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
    let!(:label_a) { FactoryBot.create(:label) }
    let!(:label_b) { FactoryBot.create(:label, label_name: 'testLabel2') }
    let!(:labelling_a) { FactoryBot.create(:labelling, task: task_a, label: label_a) }
    subject(:visit_task_a_edit){ visit edit_task_path(task_a) }

    before do
      visit login_path
      fill_in 'session[email]', with: 'testUser@example.com'
      fill_in 'session[password]', with: 'testPassword'
      click_button 'ログイン'
    end

    describe '表示機能' do
      context '画面を表示した場合' do
        it '編集前のタスク名が表示される' do
          visit_task_a_edit
          expect(page).to have_field 'タスク名', with: '最初のタスク'
        end
        it '編集前の詳細が表示される' do
          visit_task_a_edit
          expect(page).to have_field '詳細', with: '最初のタスクを実施する'
        end
        it '編集前のステータスが選択されている' do
          visit_task_a_edit
          expect(page).to have_select('task[status]', selected: '未着手')
        end
        it '編集前の優先度が選択されている' do
          visit_task_a_edit
          expect(page).to have_select('task[priority]', selected: '低')
        end
        it '編集前のラベルが選択されている' do
          visit_task_a_edit
          expect(page).to have_checked_field('testLabel')
        end
      end

      context 'ログイン者のタスクではない場合' do
        let!(:user_b) { FactoryBot.create(:user, user_name: 'testUser2', email: 'testUser2@example.com', password: 'testPassword2') }
        let!(:task_b) { FactoryBot.create(:task, name: '最初のタスク', detail: '最初のタスクを実施する', status: 1, priority: 1, user: user_b) }

        it 'エラー画面(404)が表示されること' do
          visit edit_task_path(task_b)
          expect(page).to have_content '404'
        end
      end
    end

    describe '更新機能' do
      context 'タスクの各項目を更新した場合' do
        let(:name) { '新規作成のテスト２' }
        let(:detail) { '新規作成のテストを書く２' }
        let(:status) { '未着手' }
        let(:priority) { '低' }
        let(:label) { 'testLabel' }

        it 'タスクが更新される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'タスク名', with: name
          fill_in '詳細', with: detail
          select(value = status, from: 'task[status]')
          select(value = priority, from: 'task[priority]')
          page.uncheck 'testLabel'
          page.check 'testLabel2'
          click_button '更新'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Task.eager_load(:labellings).where(name: name, detail: detail, status: 'not_started', priority: 'low',
            user_id: task_a.user.id, label_id: label_b.id)).not_to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'タスク名', with: name
          fill_in '詳細', with: detail
          select(value = status, from: 'task[status]')
          select(value = priority, from: 'task[priority]')
          page.uncheck 'testLabel'
          page.check 'testLabel2'
          click_button '更新'
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: 'タスク「新規作成のテスト２」を更新しました。'
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
