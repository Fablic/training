require 'rails_helper'

RSpec.describe 'Tasks System', type: :system, js: true do
  let(:user) { create(:user) }
  let(:task) { create(:task, name: 'task_first', deadline_at: 3.days.since, user: user) }

  describe 'タスク一覧画面(ログイン済み)' do
    let(:task_second) { create(:task, name: 'task_second', deadline_at: 2.days.since, created_at: Date.today + 1, user: user) }
    let(:task_third) { create(:task, name: 'task_third', deadline_at: 1.day.since, created_at: Date.today + 2, status: 'done', user: user) }

    before do
      task
      log_in_as user
      visit root_path
    end

    context 'タスク一覧画面に遷移した時' do
      it 'タスク一覧タイトルが表示される' do
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end

      it '登録してあるタスクが表示される' do
        expect(page).to have_content(task.name)
      end

      it '他のユーザーが作成したタスクが表示されない事' do
        other_user = create(:user, name: 'other_user', email: 'other_user@example.com')
        other_user_task = create(:task, name: 'other_user_task', user: other_user)
        expect(page).not_to have_content(other_user_task.name)
      end
    end

    context 'タスク作成リンクをクリックした時' do
      it 'タスク作成画面に遷移できる' do
        find('#new_task_link').click
        expect(page).to have_selector('h1', text: 'タスク作成')
      end
    end

    context '表示されてるタスク名を選択した時' do
      let(:other_task) { create(:task, name: 'other_task_name', user: user) }

      before do
        other_task
        visit root_path
      end

      it 'タスク詳細画面に遷移できる' do
        click_link other_task.name
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content(other_task.name)
      end
    end

    context '表示されてるタスクのEditを選択した時' do
      it 'タスク編集画面に遷移できる' do
        find("#link_edit_task_#{task.id}").click
        expect(page).to have_selector('h1', text: 'タスク編集')
      end
    end

    context 'Destroyを押して削除確認ダイアログでOKを押した時' do
      it 'タスクの削除ができる' do
        page.accept_confirm do
          find("#link_destroy_task_#{task.id}").click
        end
        expect(page).to have_content('タスク削除成功！')
        expect(page.all("#task_name_#{task.id}").empty?).to eq true
      end
    end

    context 'Destroyを押して削除確認ダイアログでキャンセルを押した時' do
      it '削除をキャンセル出来る' do
        page.dismiss_confirm do
          find("#link_destroy_task_#{task.id}").click
        end
        expect(page.has_selector?("#task_name_#{task.id}")).to eq true
      end
    end

    context 'タスクが作成日時別に複数ある時の初期表示' do
      before do
        task_second
        task_third
        visit root_path
      end

      it '作成日時の降順で表示される' do
        tr_list = all('tbody tr')
        expect(tr_list[0].first('td').text).to eq task_third.name
        expect(tr_list[1].first('td').text).to eq task_second.name
        expect(tr_list[2].first('td').text).to eq task.name
      end
    end

    context '終了期限のカラムをクリックした時' do
      it '終了期限の昇順になる' do
        find('a', text: '終了期限').click
        expect(find('#task_row_0').first('td').text).to eq task_third.name
        expect(find('#task_row_1').first('td').text).to eq task_second.name
        expect(find('#task_row_2').first('td').text).to eq task.name
      end
    end

    context '終了期限のカラムを2回クリックした時' do
      it '終了期限の降順になる' do
        find('a', text: '終了期限').click
        find('a', text: '終了期限').click
        expect(find('#task_row_0').first('td').text).to eq task.name
        expect(find('#task_row_1').first('td').text).to eq task_second.name
        expect(find('#task_row_2').first('td').text).to eq task_third.name
      end
    end

    context 'タスクとステータスを埋めて検索ボタンを押した時' do
      it '条件に合致するタスクが一覧に表示される' do
        fill_in 'search_content', with: task_third.name
        find('#search_status').find("option[value='#{task_third.status}']").select_option
        find('#search_submit').click
        expect(page).to have_selector('a', text: task_third.name)
      end
    end
  end

  describe 'タスク作成画面(ログイン済み)' do
    before do
      user
      log_in_as user
      visit new_task_path
    end

    context 'タスク作成画面に遷移した時' do
      it 'タスク作成タイトルが表示される' do
        expect(page).to have_selector('h1', text: 'タスク作成')
      end
    end

    context '新しいタスクを作成した時(ステータスはDefault)' do
      it '未着手のステータスで新しいタスクが作成される' do
        fill_in 'task_name', with: 'input Task'
        fill_in 'task_description', with: 'input Description'
        # nowだとクリックまでに時間経過してValidateに引っかかるため
        deadline_at = 1.hour.since
        find('#task_deadline_at_1i').find("option[value='#{deadline_at.strftime('%Y')}']").select_option
        find('#task_deadline_at_2i').find("option[value='#{deadline_at.month}']").select_option
        find('#task_deadline_at_3i').find("option[value='#{deadline_at.day}']").select_option
        find('#task_deadline_at_4i').find("option[value='#{deadline_at.strftime('%H')}']").select_option
        find('#task_deadline_at_5i').find("option[value='#{deadline_at.strftime('%M')}']").select_option
        find('#post_task_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content('タスク作成に成功しました！')
        expect(page).to have_content('input Task')
        expect(page).to have_content('input Description')
        expect(page).to have_content('未着手')
      end
    end

    context 'ステータスを変更して新しいタスクを作成した時' do
      it '着手中のステータスで新しいタスクが作成される' do
        fill_in 'task_name', with: 'input Task'
        fill_in 'task_description', with: 'input Description'
        # nowだとクリックまでに時間経過してValidateに引っかかるため
        deadline_at = 1.hour.since
        find('#task_status').find("option[value='in_progress']").select_option
        find('#task_deadline_at_1i').find("option[value='#{deadline_at.strftime('%Y')}']").select_option
        find('#task_deadline_at_2i').find("option[value='#{deadline_at.month}']").select_option
        find('#task_deadline_at_3i').find("option[value='#{deadline_at.day}']").select_option
        find('#task_deadline_at_4i').find("option[value='#{deadline_at.strftime('%H')}']").select_option
        find('#task_deadline_at_5i').find("option[value='#{deadline_at.strftime('%M')}']").select_option
        find('#post_task_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content('タスク作成に成功しました！')
        expect(page).to have_content('input Task')
        expect(page).to have_content('input Description')
        expect(page).to have_content(I18n.l(deadline_at, format: :long_ja))
        expect(page).to have_content('着手中')
      end
    end

    context '一覧に戻るリンクをクリックした時' do
      it 'タスク一覧画面が表示される' do
        find('#back_root_link').click
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end
  end

  describe 'タスク詳細画面(ログイン済み)' do
    before do
      log_in_as user
      visit task_path task
    end

    context 'タスク詳細画面に遷移した時' do
      it 'タスク詳細タイトルが表示される' do
        expect(page).to have_selector('h1', text: 'タスク詳細')
      end

      it '選択したタスクの詳細情報が表示される' do
        expect(page).to have_content(task.name)
        expect(page).to have_content(task.description)
        expect(page).to have_content(I18n.l(task.deadline_at, format: :long_ja))
        expect(page).to have_content(task.status_i18n)
      end
    end

    context '一覧に戻るリンクをクリックした時' do
      it 'タスク一覧画面が表示される' do
        find('#back_root_link').click
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end
  end

  describe 'タスク編集画面(ログイン済み)' do
    before do
      log_in_as user
      visit edit_task_path task
    end

    context 'タスク編集画面に遷移した時' do
      it 'タスク編集タイトルが表示される' do
        expect(page).to have_selector('h1', text: 'タスク編集')
      end
    end

    context 'タスクの情報を更新した時' do
      it 'タスクの情報が変更されている' do
        fill_in 'task_name', with: 'update Task'
        fill_in 'task_description', with: 'update Description'
        deadline_at = 1.week.since
        find('#task_status').find("option[value='in_progress']").select_option
        find('#task_deadline_at_1i').find("option[value='#{deadline_at.strftime('%Y')}']").select_option
        find('#task_deadline_at_2i').find("option[value='#{deadline_at.month}']").select_option
        find('#task_deadline_at_3i').find("option[value='#{deadline_at.day}']").select_option
        find('#task_deadline_at_4i').find("option[value='#{deadline_at.strftime('%H')}']").select_option
        find('#task_deadline_at_5i').find("option[value='#{deadline_at.strftime('%M')}']").select_option
        find('#post_task_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content('タスク更新に成功しました！')
        expect(page).to have_content('update Task')
        expect(page).to have_content('update Description')
        expect(page).to have_content(I18n.l(deadline_at, format: :long_ja))
        expect(page).to have_content('着手中')
      end
    end

    context '一覧に戻るリンクをクリックした時' do
      it 'タスク一覧画面が表示される' do
        find('#back_root_link').click
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end
  end

  describe '未ログイン状態' do
    context 'タスク一覧画面に遷移した時' do
      before do
        visit root_path
      end

      it 'ログイン画面が表示される' do
        expect(page).to have_selector('h1', text: 'ログイン')
      end

      it 'ログイン画面が表示されてログインしてタスク一覧画面が表示される' do
        expect(page).to have_selector('h1', text: 'ログイン')
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        find('#login_button').click
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end

    context 'タスク作成画面に遷移した時' do
      before do
        visit new_task_path
      end

      it 'ログイン画面が表示される' do
        expect(page).to have_selector('h1', text: 'ログイン')
      end

      it 'ログイン画面が表示されてログインしてタスク作成画面が表示される' do
        expect(page).to have_selector('h1', text: 'ログイン')
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        find('#login_button').click
        expect(page).to have_selector('h1', text: 'タスク作成')
      end
    end

    context 'タスク詳細画面に遷移した時' do
      before do
        visit task_path task
      end

      it 'ログイン画面が表示される' do
        expect(page).to have_selector('h1', text: 'ログイン')
      end

      it 'ログイン画面が表示されてログインしてタスク作成画面が表示される' do
        expect(page).to have_selector('h1', text: 'ログイン')
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        find('#login_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
      end
    end

    context 'タスク編集画面に遷移した時' do
      before do
        visit edit_task_path task
      end

      it 'ログイン画面が表示される' do
        expect(page).to have_selector('h1', text: 'ログイン')
      end

      it 'ログイン画面が表示されてログインしてタスク作成画面が表示される' do
        expect(page).to have_selector('h1', text: 'ログイン')
        fill_in 'session_email', with: user.email
        fill_in 'session_password', with: user.password
        find('#login_button').click
        expect(page).to have_selector('h1', text: 'タスク編集')
      end
    end
  end
end
