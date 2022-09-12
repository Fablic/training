require 'rails_helper'

describe 'タスク管理機能', type: :system do
  let!(:maintenance) { FactoryBot.create(:maintenance) }
  let(:user) { FactoryBot.create(:user, password_digest: 'password') }

  describe '検索エリア' do

    before do
      login(user, 'password')
    end

    context '条件なし検索' do

      let!(:task_A1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id) }
      let!(:task_B1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id) }
      let(:conditions) { { title: '', status: '' } }

      it '検索結果の件数が一致すること' do
        visit root_path
        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'
        expect(all('tbody tr').size).to be(4)
      end

      it 'titleA1が表示されること' do
        visit root_path
        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されること' do
        visit root_path
        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA2'
      end

      it 'titleB1が表示されること' do
        visit root_path
        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleB1'
      end

      it 'titleB2が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleB2'
      end
    end

    context 'wordのみ指定して検索' do
      let!(:task_A1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id) }
      let!(:task_B1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id) }
      let(:conditions) { { title: 'A' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(all('tbody tr').size).to be(2)
      end

      it 'titleA1が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA2'
      end

      it 'titleB1が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB1'
      end

      it 'titleB2が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:title]
        select value = '', from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB2'
      end
    end

    context 'statusのみ指定して検索' do
      let!(:task_A1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id) }
      let!(:task_B1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id) }
      let(:conditions) { { status: '未着手' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(all('tbody tr').size).to be(2)
      end

      it 'titleA1が表示されること' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されないこと' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleA2'
      end

      it 'titleB1が表示されること' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
         click_on '検索'

        expect(page).to have_content 'titleB1'
      end

      it 'titleB2が表示されないこと' do
        visit root_path

        fill_in 'title', with: ''
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB2'
      end

    end

    context 'word、statusを指定して検索' do
      let!(:task_A1) { FactoryBot.create(:task, title: 'titleA1', status: 'not_started', user_id: user.id) }
      let!(:task_A2) { FactoryBot.create(:task, title: 'titleA2', status: 'in_progress', user_id: user.id) }
      let!(:task_B1) { FactoryBot.create(:task, title: 'titleB1', status: 'not_started', user_id: user.id) }
      let!(:task_B2) { FactoryBot.create(:task, title: 'titleB2', status: 'in_progress', user_id: user.id) }
      let(:conditions) { { word: 'A', status: '未着手' } }

      it '検索結果の件数が一致すること' do
        visit root_path

        fill_in 'title', with: conditions[:word]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(all('tbody tr').size).to be(1)
      end

      it 'titleA1が表示されること' do
        visit root_path

        fill_in 'title', with: conditions[:word]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).to have_content 'titleA1'
      end

      it 'titleA2が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:word]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleA2'
      end

      it 'titleB1が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:word]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB1'
      end

      it 'titleB2が表示されないこと' do
        visit root_path

        fill_in 'title', with: conditions[:word]
        select value = conditions[:status], from: 'status'
        click_on '検索'

        expect(page).not_to have_content 'titleB2'
      end
    end
  end

  describe '一覧表示機能' do
    subject(:visit_tasks) { visit tasks_path }

    before do
      login(user, 'password')
    end

    describe '表示機能'do
      let!(:maintenance) { FactoryBot.create(:maintenance) }

      context 'タスクが1件存在する場合' do
        let!(:task_1) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: '1') }

        let(:tds){ all('tbody tr')[0].all('td') }
        it 'タスク名が表示される' do
          visit_tasks
          expect(tds[0]).to have_content task_1.title
        end

        it '説明が表示される' do
          visit_tasks
          expect(tds[1]).to have_content task_1.description
        end
      end

      context 'タスクが2件(複数)存在する場合' do
        let!(:task_1) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: '1') }
        let!(:task_2) { FactoryBot.create(:task, title: '２つ目のタスク', description: '２つ目のタスクを実施する', user_id: user.id, status: '1') }

        it 'タスク名が表示される' do
          visit_tasks
          expect(page).to have_content task_2.title
        end

        it '説明が表示される' do
          visit_tasks
          expect(page).to have_content task_2.description
        end
      end
    end

    describe '画面遷移機能' do
      let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: '1') }
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
    let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id) }
    subject(:visit_task_a) { visit task_path(task_a) }

    before do
      login(user, 'password')
    end

    describe '表示機能' do
      context 'タスクが存在する場合' do
        it 'タスク名が表示される' do
          visit_task_a
          expect(page).to have_content task_a[:title]
        end

        it '詳細が表示される' do
          visit_task_a
          expect(page).to have_content task_a[:description]
        end

        it 'ステータスが表示される' do
          visit_task_a
          expect(page).to have_content task_a[:status]
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
          expect(Task.find_by(title: task_a.title)).to be_nil
        end

        it 'Flashメッセージが表示される' do
          visit_task_a
          click_on('削除')
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: "タスク「#{task_a.title}」を削除しました。"
        end
      end

      context '削除ボタンをクリックした場合' do
        it '編集画面へ遷移できる' do
          visit_task_a
          click_on('削除')
          expect(page).to have_current_path tasks_path
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

    before do
      login(user, 'password')
    end

    describe '登録機能' do
      context 'タスクの内容を入力した場合' do
        let(:input_values) {
          {
            title: '新規作成のテスト2',
            description: '新規作成のテストを書く2',
            user_id: user.id,
          }
        }

        it 'タスクの件数が1件増える' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          # DBに登録されている
          expect { click_button 'submit' }.to change(Task, :count).by(1)
        end

        it '入力された内容でタスクが作成される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          click_button 'submit'
          # 画面で入力された内容でDBに登録されている
          expect(Task.find_by(input_values)).to be_present
        end

        it 'Flashメッセージが表示される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]
          # Flashメッセージが表示される
          click_button 'submit'
          expect(page).to have_selector '.alert-success', text: 'タスクを登録しました'
        end

        it '一覧画面が表示される' do
          # タスク内容入力
          visit_new_task
          fill_in 'textarea1', with: input_values[:title]
          fill_in 'textarea2', with: input_values[:description]

          click_button 'submit'
          expect(page).to have_current_path root_path
        end
      end
    end

    describe '画面遷移機能' do
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
    let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: '1') }
    subject(:visit_task_a_edit){visit edit_task_path(task_a)}

    before do
      login(user, 'password')
    end

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

        it 'タスクが更新される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'textarea1', with: title
          fill_in 'textarea2', with: description
          click_button 'submit'
          # 画面で入力された内容でDBのデータが更新されている
          expect(Task.find_by(title: title, description: description)).to be_present
        end

        it 'Flashメッセージが表示される' do
          visit_task_a_edit
          # 更新処理
          fill_in 'textarea1', with: title
          fill_in 'textarea2', with: description
          click_button 'submit'
          # Flashメッセージが表示される
          expect(page).to have_selector '.alert-success', text: 'タスクを更新しました'
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
          click_link '一覧に戻る'
          expect(page).to have_current_path tasks_path
        end
      end
    end
  end

  describe 'メンテナンス機能' do
    let!(:maintenance) { FactoryBot.create(:maintenance) }
    let(:user) { FactoryBot.create(:user, password_digest: 'password') }

    describe 'メンテナンス中の場合' do
      let!(:maintenance) { FactoryBot.create(:maintenance, maintenance_flg: true) }

      context 'ログイン画面の場合' do

        it 'メンテナンス中画面が表示される' do
          visit login_path
          expect(page).to have_content 'メンテナンス中'
        end
      end

      context '一覧画面の場合' do
        subject(:visit_tasks) { visit tasks_path }

        it 'メンテナンス中画面が表示される' do
          visit visit_tasks
          expect(page).to have_content 'メンテナンス中'
        end
      end

      context '登録画面の場合' do
        subject(:visit_new_task){ visit new_task_path }

        it 'メンテナンス中画面が表示される' do
          visit_new_task
          expect(page).to have_content 'メンテナンス中'
        end
      end

      context '編集画面の場合' do
        let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: '1') }
        subject(:visit_task_a_edit){visit edit_task_path(task_a)}

        it 'メンテナンス中画面が表示される' do
          visit_task_a_edit
          expect(page).to have_content 'メンテナンス中'
        end
      end

      context '詳細画面の場合' do
        let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id) }
        subject(:visit_task_a) { visit task_path(task_a) }

        it 'メンテナンス中画面が表示される' do
          visit_task_a
          expect(page).to have_content 'メンテナンス中'
        end
      end
    end

    describe 'メンテナンス中でない場合' do

      before do
        login(user, 'password')
      end

      context 'ログイン画面の場合' do

        it  'ログイン画面が表示される' do
          visit login_path
          expect(page).to have_content 'ログイン'
        end
      end

      context '一覧画面の場合' do

        it  '一覧画面が表示される' do
          visit login_path
          fill_in 'session[email]', with: 'sample12345@example.com'
          fill_in 'session[password]', with: 'password'
          click_button 'ログイン'

          tasks_path
          expect(page).to have_content 'タスク一覧'
        end
      end

      context '登録画面の場合' do
        subject(:visit_new_task){ visit new_task_path }

        it  '登録画面が表示される' do
          visit login_path
          fill_in 'session[email]', with: 'sample12345@example.com'
          fill_in 'session[password]', with: 'password'
          click_button 'ログイン'

          visit_new_task
          expect(page).to have_content 'タスク登録'
        end
      end

      context '編集画面の場合' do
        let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id, status: '1') }
        subject(:visit_task_a_edit){visit edit_task_path(task_a)}

        it  '編集画面が表示される' do
          visit login_path
          fill_in 'session[email]', with: 'sample12345@example.com'
          fill_in 'session[password]', with: 'password'
          click_button 'ログイン'

          visit_task_a_edit
          expect(page).to have_content 'タスク編集'
        end
      end

      context '詳細画面の場合' do
        let!(:task_a) { FactoryBot.create(:task, title: '最初のタスク', description: '最初のタスクを実施する', user_id: user.id) }
        subject(:visit_task_a) { visit task_path(task_a) }

        it  '詳細画面が表示される' do
          visit login_path
          fill_in 'session[email]', with: 'sample12345@example.com'
          fill_in 'session[password]', with: 'password'
          click_button 'ログイン'

          visit_task_a
          expect(page).to have_content '最初のタスクの詳細'
        end
      end
    end
  end
end
