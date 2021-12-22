require 'rails_helper'

RSpec.describe 'Tasks System', type: :system, js: true do
  let(:user) { create(:user) }
  let(:label_one) { create(:label) }
  let(:label_second) { create(:label) }
  let(:label_third) { create(:label) }
  let(:task) { create(:task, name: 'task_first', deadline_at: 3.days.since, user: user) }
  let(:labeled_task) { create(:task, name: 'labeled_task', status: 'done', user: user, labels: [label_one, label_second, label_third]) }
  let(:non_labeled_task) { create(:task, name: 'non_labeled_task', user: user) }

  describe 'タスク一覧画面(ログイン済み)' do
    let(:task_second) { create(:task, name: 'task_second', deadline_at: 2.days.since, created_at: Date.today + 1, user: user) }
    let(:task_third) { create(:task, name: 'task_third', deadline_at: 1.day.since, created_at: Date.today + 2, status: 'done', user: user) }

    before do
      label_one
      labeled_task
      non_labeled_task
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

    context 'ラベルを指定して検索したとき' do
      before do
        find("#label_check_#{label_one.id}").set(true)
        find('#search_submit').click
      end

      it '指定したラベルが付いてるタスクが一覧に表示される事' do
        expect(page).to have_selector('a', text: labeled_task.name)
      end

      it '指定したラベルが付いていないタスクが表示されない事' do
        expect(page).not_to have_selector('a', text: non_labeled_task.name)
      end
    end

    context 'ラベルとテキストを指定して検索したとき' do
      before do
        fill_in 'search_content', with: labeled_task.name
        find("#label_check_#{label_one.id}").set(true)
        find('#search_submit').click
      end

      it '(指定したラベルANDテキスト一致)のタスクが一覧に表示される事' do
        expect(page).to have_selector('a', text: labeled_task.name)
      end

      it '(指定したラベルANDテキスト一致)に該当しないタスクが表示されない事' do
        expect(page).not_to have_selector('a', text: non_labeled_task.name)
      end
    end

    context 'ラベルとステータスとテキストを指定して検索したとき' do
      before do
        fill_in 'search_content', with: labeled_task.name
        find('#search_status').find("option[value='done']").select_option
        find("#label_check_#{label_one.id}").set(true)
        find('#search_submit').click
      end

      it '(指定したラベルANDテキスト一致ANDステータス)のタスクが一覧に表示される事' do
        expect(page).to have_selector('a', text: labeled_task.name)
      end

      it '(指定したラベルANDテキスト一致ANDステータス)に該当しないタスクが表示されない事' do
        expect(page).not_to have_selector('a', text: non_labeled_task.name)
      end
    end
  end

  describe 'タスク作成画面(ログイン済み)' do
    before do
      user
      label_one
      label_second
      label_third
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

    context 'ラベルをチェックして新しいタスクを作成した時(一つだけチェックしない)' do
      it 'チェックしたラベルが付与された状態でで新しいタスクが作成される' do
        fill_in 'task_name', with: 'input Task'
        fill_in 'task_description', with: 'input Description'
        find("#label_check_#{label_one.id}").set(true)
        find("#label_check_#{label_second.id}").set(true)
        find("#label_check_#{label_third.id}").set(false) # 明示的にチェックを外す（デフォルトで外れてるが）
        find('#post_task_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content('タスク作成に成功しました！')
        expect(page).to have_content('input Task')
        expect(page).to have_content('input Description')
        expect(page).to have_content(label_one.name)
        expect(page).to have_content(label_second.name)
        expect(page).not_to have_content(label_third.name) # 表示されない事
      end
    end

    context 'ラベルをチェックしないで新しいタスクを作成した時' do
      it 'ラベルが付与されない状態で新しいタスクが作成される事' do
        fill_in 'task_name', with: 'input Task'
        fill_in 'task_description', with: 'input Description'
        # 明示的にチェックを外す（デフォルトで外れてるが）
        find("#label_check_#{label_one.id}").set(false)
        find("#label_check_#{label_second.id}").set(false)
        find("#label_check_#{label_third.id}").set(false)

        find('#post_task_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content('タスク作成に成功しました！')
        expect(page).to have_content('input Task')
        expect(page).to have_content('input Description')
        # 表示されない事
        expect(page).not_to have_content(label_one.name)
        expect(page).not_to have_content(label_second.name)
        expect(page).not_to have_content(label_third.name)
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
    end

    context 'タスク詳細画面に遷移した時' do
      before do
        visit task_path task
      end

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

    context 'ラベル付きのタスク詳細画面に遷移した時' do
      before do
        visit task_path labeled_task
      end

      it 'ラベル付きのタスクのラベル情報が表示される事' do
        expect(page).to have_content(labeled_task.name)
        labeled_task.labels.each do |label|
          expect(page).to have_content(label.name)
        end
      end
    end

    context 'ラベルなしのタスク詳細画面に遷移した時' do
      before do
        visit task_path non_labeled_task
      end

      it 'ラベルなしタスクのラベルが表示されない事' do
        expect(page).to have_selector('#task_label_value', text: '')
      end
    end

    context '一覧に戻るリンクをクリックした時' do
      before do
        visit task_path task
      end

      it 'タスク一覧画面が表示される' do
        find('#back_root_link').click
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end
  end

  describe 'タスク編集画面(ログイン済み)' do
    before do
      label_one
      label_second
      label_third
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

    context 'ラベルをチェックして更新した時(一つだけチェックしない)' do
      it 'チェックしたラベルが付与された状態で更新される' do
        fill_in 'task_name', with: 'update Task'
        fill_in 'task_description', with: 'update Description'
        find("#label_check_#{label_one.id}").set(true)
        find("#label_check_#{label_second.id}").set(true)
        find("#label_check_#{label_third.id}").set(false)
        find('#post_task_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content('タスク更新に成功しました！')
        expect(page).to have_content('update Task')
        expect(page).to have_content('update Description')
        expect(page).to have_content(label_one.name)
        expect(page).to have_content(label_second.name)
        expect(page).not_to have_content(label_third.name) # 表示されない事
      end
    end

    context 'ラベルを全てチェック外してタスクを更新した時' do
      before do
        visit edit_task_path labeled_task
      end

      it 'ラベルが全て外れた状態で更新される事' do
        fill_in 'task_name', with: 'update Task'
        fill_in 'task_description', with: 'update Description'
        labeled_task.label_ids.each do |label_id|
          find("#label_check_#{label_id}").set(false)
        end
        find('#post_task_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content('タスク更新に成功しました！')
        expect(page).to have_content('update Task')
        expect(page).to have_content('update Description')
        # 表示されない事
        labeled_task.labels.each do |label|
          expect(page).not_to have_content(label.name)
        end
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
