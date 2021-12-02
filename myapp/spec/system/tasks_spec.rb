require 'rails_helper'

RSpec.describe 'Tasks System', type: :system, js: true do
  let(:task) { create(:task, deadline_at: 3.days.since) }
  # Listで作ると降順にならないので一旦この作り方
  let(:task_second) { create(:task, deadline_at: 2.days.since, created_at: Date.today + 1) }
  let(:task_third) { create(:task, deadline_at: 1.day.since, created_at: Date.today + 2) }

  describe 'タスク一覧画面' do
    before do
      task
      task_second
      task_third
      visit root_path
    end

    context 'タスク一覧画面に遷移した時' do
      it 'タスク一覧タイトルが表示される' do
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end

      it '登録してあるタスクが表示される' do
        expect(page).to have_content(task.name)
      end
    end

    context 'タスク作成リンクをクリックした時' do
      it 'タスク作成画面に遷移できる' do
        find('#new_task_link').click
        expect(page).to have_selector('h1', text: 'タスク作成')
      end
    end

    context '表示されてるタスク名を選択した時' do
      let(:other_task) { create(:task, name: 'other_task_name') }

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
        find('#tasks_deadline_at_link').click
        expect(find('#task_row_0').first('td').text).to eq task_third.name
        expect(find('#task_row_1').first('td').text).to eq task_second.name
        expect(find('#task_row_2').first('td').text).to eq task.name
      end
    end

    context '終了期限のカラムを2回クリックした時' do
      it '終了期限の降順になる' do
        find('#tasks_deadline_at_link').click
        find('#tasks_deadline_at_link').click
        expect(find('#task_row_0').first('td').text).to eq task.name
        expect(find('#task_row_1').first('td').text).to eq task_second.name
        expect(find('#task_row_2').first('td').text).to eq task_third.name
      end
    end
  end

  describe 'タスク作成画面' do
    before do
      visit new_task_path
    end

    context 'タスク作成画面に遷移した時' do
      it 'タスク作成タイトルが表示される' do
        expect(page).to have_selector('h1', text: 'タスク作成')
      end
    end

    context '新しいタスクを作成した時' do
      it '新しいタスクが作成される' do
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
      end
    end

    context '一覧に戻るリンクをクリックした時' do
      it 'タスク一覧画面が表示される' do
        find('#back_root_link').click
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end
  end

  describe 'タスク詳細画面' do
    before do
      visit task_path task
    end

    context 'タスク詳細画面に遷移した時' do
      it 'タスク詳細タイトルが表示される' do
        expect(page).to have_selector('h1', text: 'タスク詳細')
      end

      it '選択したタスクの詳細情報が表示される' do
        expect(page).to have_content(task.name)
        expect(page).to have_content(task.description)
      end
    end

    context '一覧に戻るリンクをクリックした時' do
      it 'タスク一覧画面が表示される' do
        find('#back_root_link').click
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end
  end

  describe 'タスク編集画面' do
    before do
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
        find('#post_task_button').click
        expect(page).to have_selector('h1', text: 'タスク詳細')
        expect(page).to have_content('タスク更新に成功しました！')
        expect(page).to have_content('update Task')
        expect(page).to have_content('update Description')
      end
    end

    context '一覧に戻るリンクをクリックした時' do
      it 'タスク一覧画面が表示される' do
        find('#back_root_link').click
        expect(page).to have_selector('h1', text: 'タスク一覧')
      end
    end
  end
end
