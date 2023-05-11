require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:task) { create(:task) }

  describe 'タスク表示' do
    context 'DBに保存されたデータがある' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/27',
                      status: '未着手', created_at: '2023/04/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/26',
                      status: '着手中', created_at: '2023/04/27 08:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/28',
                      status: '完了済', created_at: '2023/04/27 10:00')
        visit root_path
      end

      it '一覧ページに作成日降順で表示' do
        expect(current_path).to eq root_path
        expect(page).to have_content '1'
        expect(page).to have_content 'task1'
        expect(page).to have_content 'task_contetnt1'
        expect(page).to have_content '2023/04/27'
        expect(page).to have_content '未着手'
        expect(page).to have_content '2023/04/27 09:00'
        expect(page).to have_content '2'
        expect(page).to have_content 'task2'
        expect(page).to have_content 'task_contetnt2'
        expect(page).to have_content '2023/04/26'
        expect(page).to have_content '着手中'
        expect(page).to have_content '2023/04/27 08:00'
        expect(page).to have_content '3'
        expect(page).to have_content 'task3'
        expect(page).to have_content 'task_contetnt3'
        expect(page).to have_content '2023/04/28'
        expect(page).to have_content '完了済'
        expect(page).to have_content '2023/04/27 10:00'

        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
        expect(page).to have_link '昇順', href: tasks_path(deadline_asc: 'true')
        expect(page).to have_link '降順', href: tasks_path(deadline_desc: 'true')
        expect(page).to have_field 'word'
        expect(page).to have_select(options: ['------', '未着手', '着手中', '完了済'])
        expect(page).to have_button '検索'


        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task3 task1 task2]
        end
      end
    end

    context '一覧ページの終了期限の昇順ボタンが押された' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/29',
                      status: '未着手', created_at: '2023/04/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/28',
                      status: '着手中', created_at: '2023/04/27 08:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/27',
                      status: '完了済', created_at: '2023/04/27 10:00')
        visit root_path
      end

      it '終了期限の昇順で表示' do
        click_on '昇順'

        expect(current_path).to eq tasks_path
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task3 task2 task1]
        end
      end
    end

    context '一覧ページの終了期限の降順ボタンが押された' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/29',
                      status: '未着手', created_at: '2023/04/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/28',
                      status: '着手中', created_at: '2023/04/27 08:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', deadline: '2023/04/27',
                      status: '完了済', created_at: '2023/04/27 10:00')
        visit root_path
      end

      it '終了期限の降順で表示' do
        click_on '降順'

        expect(current_path).to eq tasks_path
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task1 task2 task3]
        end
      end
    end

    context 'タスク名、ステータスを入力して検索' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/29',
                      status: '未着手', created_at: '2023/01/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/28',
                      status: '着手中', created_at: '2023/03/27 08:00')
        visit root_path
      end

      it '条件に合致するタスクが一覧に表示' do
        fill_in 'search_word', with: 'task'
        find('#search_status').find("option[value='not_started_task']").select_option
        find('#search_submit').click

        expect(current_path).to eq search_tasks_path
        expect(page).to have_content '1'
        expect(page).to have_selector('td', text: 'task1')
        expect(page).to have_content 'task_contetnt1'
        expect(page).to have_content '2023/04/29'
        expect(page).to have_selector('td', text: '未着手')
        expect(page).to have_content '2023/01/27 09:00'
      end
    end

    context 'タスク名のみ入力して検索' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/29',
                      status: '未着手', created_at: '2023/01/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/28',
                      status: '着手中', created_at: '2023/03/27 08:00')
        visit root_path
      end

      it '全てのタスクが一覧に表示' do
        fill_in 'search_word', with: 'task'
        find('#search_submit').click

        expect(current_path).to eq search_tasks_path
        expect(page).to have_content '1'
        expect(page).to have_selector('td', text: 'task1')
        expect(page).to have_content 'task_contetnt1'
        expect(page).to have_content '2023/04/29'
        expect(page).to have_selector('td', text: '未着手')
        expect(page).to have_content '2023/01/27 09:00'
        expect(page).to have_content '2'
        expect(page).to have_selector('td', text: 'task2')
        expect(page).to have_content 'task_contetnt2'
        expect(page).to have_content '2023/04/28'
        expect(page).to have_selector('td', text: '未着手')
        expect(page).to have_content '2023/03/27 08:00'
      end
    end

    context 'ステータスのみ入力して検索' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', deadline: '2023/04/29',
                      status: '未着手', created_at: '2023/01/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', deadline: '2023/04/28',
                      status: '着手中', created_at: '2023/03/27 08:00')
        visit root_path
      end

      it '条件に合致するタスクを一覧に表示' do
        fill_in 'search_word', with: 'task'
        find('#search_status').find("option[value='started_task']").select_option
        find('#search_submit').click

        expect(current_path).to eq search_tasks_path
        expect(page).to have_content '2'
        expect(page).to have_selector('td', text: 'task2')
        expect(page).to have_content 'task_contetnt2'
        expect(page).to have_content '2023/04/28'
        expect(page).to have_selector('td', text: '着手中')
        expect(page).to have_content '2023/03/27 08:00'
      end
    end

    context 'DBに保存されたデータがない' do
      it '一覧ページに新規登録ボタンのみ表示' do
        visit root_path

        expect(current_path).to eq root_path
        expect(page).to have_no_content task.id
        expect(page).to have_no_content task.title
        expect(page).to have_no_content task.content
        expect(page).to have_no_content task.deadline
        expect(page).to have_no_content task.status
        expect(page).to have_no_link '詳細'
        expect(page).to have_no_link '編集'
        expect(page).to have_no_link '削除'
        expect(page).to have_no_field 'word'
        expect(page).to have_no_select(options: ['------', '未着手', '着手中', '完了済'])
        expect(page).to have_no_button '検索'
        expect(page).to have_link '新規登録'
      end
    end

    context '詳細タスクがある' do
      it '詳細ページの表示' do
        visit task_path(task.id)

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_link 'もどる'
      end
    end

    context '詳細タスクがない' do
      it '該当するリソースがないと表示' do
        task.destroy

        visit task_path(task.id)

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'タスク登録' do
    it '新規登録ページ表示' do
      visit root_path

      expect(page).to have_link '新規登録'

      click_on '新規登録'

      expect(current_path).to eq new_task_path
      expect(page).to have_field 'task[title]'
      expect(page).to have_field 'task[content]'
      expect(page).to have_field 'task[deadline]'
      expect(page).to have_field 'task[status]'
      expect(page).to have_button '登録'
      expect(page).to have_link 'もどる'
    end

    context 'タスク名、概要、終了期限、ステータスを入力' do
      it 'タスクの登録に成功' do
        visit new_task_path

        fill_in 'task[title]', with: 'test_title'
        fill_in 'task[content]', with: 'test_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
        expect(page).to have_content '2022/03/27'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'タスクの登録に成功しました。'
      end
    end

    context '概要が未入力' do
      it 'タスクの登録に成功' do
        visit new_task_path

        fill_in 'task[title]', with: 'test_title'
        fill_in 'task[content]', with: ''
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'test_title'
        expect(page).to have_selector('td', text: '')
        expect(page).to have_content '2022/03/27'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'タスクの登録に成功しました。'
      end
    end

    context 'タスク名が未入力' do
      it 'タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'test_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク名を入力してください'
      end
    end

    context 'タスク名が31文字以上で入力' do
      it 'タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: 'a' * 31
        fill_in 'task[content]', with: 'test_content'
        select(value = '着手中', from: 'task[status]')
        fill_in 'task[deadline]', with: '2022/03/27'
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスク名は30文字以内で入力してください'
      end
    end

    context '終了期限が未入力' do
      it 'タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: 'update_title'
        fill_in 'task[content]', with: 'test_content'
        fill_in 'task[deadline]', with: ''
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content '終了期限を入力してください'
      end
    end

    context 'ステータスが未選択' do
      it 'タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: 'test_title'
        fill_in 'task[content]', with: 'test_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '------', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'ステータスは一覧にありません'
      end
    end
  end

  describe 'タスク編集' do
    let!(:task) { create(:task) }

    context '編集タスクがある' do
      it '編集ページの表示に成功' do
        visit root_path

        expect(page).to have_link '編集'

        click_on '編集'

        expect(current_path).to eq edit_task_path(task.id)
        expect(page).to have_field 'task[title]'
        expect(page).to have_field 'task[content]'
        expect(page).to have_field 'task[deadline]'
        expect(page).to have_field 'task[status]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end
    end

    context '編集タスクがない' do
      it '該当するリソースがないと表示' do
        task.destroy

        visit edit_task_path(task.id)

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end

    context 'タスク名、概要、終了期限、ステータスを入力' do
      it 'タスクの更新に成功' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_on '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'update_test'
        expect(page).to have_content 'update_content'
        expect(page).to have_content '2022/03/27'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'タスクの更新に成功しました。'
      end
    end

    context '概要が未入力' do
      it 'タスクの更新に成功' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: ''
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'update_test'
        expect(page).to have_selector('td', text: '')
        expect(page).to have_content '2022/03/27'
        expect(page).to have_content '未着手'
        expect(page).to have_content 'タスクの更新に成功しました。'
      end
    end

    context 'タスク名が未入力' do
      it 'タスクの更新に失敗' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content 'タスク名を入力してください'
      end
    end

    context 'タスク名が３１文字以上' do
      it 'タスクの更新に失敗' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'a' * 31
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content 'タスク名は30文字以内で入力してください'
      end
    end

    context '終了期限が未入力' do
      it 'タスクの更新に失敗' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: ''
        select(value = '着手中', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content '終了期限を入力してください'
      end
    end

    context 'ステータスが未選択' do
      it 'タスクの更新に失敗' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '------', from: 'task[status]')
        click_button '登録'

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content 'ステータスは一覧にありません'
      end
    end

    context '更新タスクがない' do
      it '該当するリソースがないと表示' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        fill_in 'task[deadline]', with: '2022/03/27'
        select(value = '着手中', from: 'task[status]')
        task.destroy
        click_button '登録'

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'タスク削除' do
    let!(:task) { create(:task) }

    context '削除タスクがある' do
      it 'タスクの削除に成功' do
        visit root_path

        expect(page).to have_link '削除'

        click_on '削除'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスクの削除に成功しました。'
        expect(page).not_to have_content task.title
      end
    end

    context '削除タスクがない' do
      it '該当するリソースがないと表示' do
        visit root_path

        task.destroy
        click_on '削除'

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end
end
