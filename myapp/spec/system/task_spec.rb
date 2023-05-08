require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:task) { create(:task) }

  describe 'タスク表示' do
    context 'DBに保存されたデータがある時' do
      before do
        create(:task, id: '1', title: 'task1', content: 'task_contetnt1', created_at: '2023/04/27 09:00')
        create(:task, id: '2', title: 'task2', content: 'task_contetnt2', created_at: '2023/04/27 08:00')
        create(:task, id: '3', title: 'task3', content: 'task_contetnt3', created_at: '2023/04/27 10:00')
        visit root_path
      end

      it '作成日降順で表示' do
        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '1'
        expect(page).to have_content 'task1'
        expect(page).to have_content 'task_contetnt1'
        expect(page).to have_content '2023/04/27 09:00'
        expect(page).to have_content '2'
        expect(page).to have_content 'task2'
        expect(page).to have_content 'task_contetnt2'
        expect(page).to have_content '2023/04/27 08:00'
        expect(page).to have_content '3'
        expect(page).to have_content 'task3'
        expect(page).to have_content 'task_contetnt3'
        expect(page).to have_content '2023/04/27 10:00'

        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'

        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[task3 task1 task2]
        end
      end
    end

    context 'DBに保存されたデータがない時' do
      it '新規登録ボタンのみ表示' do
        visit root_path

        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).not_to have_content task.id
        expect(page).not_to have_content task.title
        expect(page).not_to have_content task.content
        expect(page).not_to have_link '詳細'
        expect(page).not_to have_link '編集'
        expect(page).not_to have_link '削除'
        expect(page).to have_link '新規登録'
      end
    end

    context '詳細' do
      it '詳細タスクがある場合、詳細ページの表示に成功' do
        visit task_path(task.id)

        expect(page).to have_current_path task_path(task.id), ignore_query: true
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_link 'もどる'
      end

      it '詳細タスクがない場合、該当するタスクがないと表示' do
        task.destroy

        visit task_path(task.id)

        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'タスク登録' do
    it '新規登録ページ表示' do
      visit root_path

      expect(page).to have_link '新規登録'

      click_on '新規登録'

      expect(page).to have_current_path new_task_path, ignore_query: true
      expect(page).to have_field 'task[title]'
      expect(page).to have_field 'task[content]'
      expect(page).to have_button '登録'
      expect(page).to have_link 'もどる'
    end

    context '登録成功' do
      it '全て入力した場合、タスクの登録に成功' do
        visit new_task_path

        fill_in 'task[title]', with: 'test_title'
        fill_in 'task[content]', with: 'test_content'
        click_button '登録'

        expect(page).to have_current_path tasks_path, ignore_query: true
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
        expect(page).to have_content 'タスクの登録に成功しました。'
      end

      it '概要が未入力の場合、タスクの登録に成功' do
        visit new_task_path

        fill_in 'task[title]', with: 'test_title'
        fill_in 'task[content]', with: ''
        click_button '登録'

        expect(page).to have_current_path tasks_path, ignore_query: true
        expect(page).to have_content 'test_title'
        expect(page).to have_selector('td', text: '')
        expect(page).to have_content 'タスクの登録に成功しました。'
      end
    end

    context '登録失敗' do
      it 'タイトル名が未入力の場合、タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'test_content'
        click_button '登録'

        expect(page).to have_current_path tasks_path, ignore_query: true
        expect(page).to have_content 'タスク名を入力してください'
      end

      it 'タイトル名が31字以上の場合、タスクの登録に失敗' do
        visit new_task_path

        fill_in 'task[title]', with: 'a' * 31
        fill_in 'task[content]', with: 'test_content'
        click_button '登録'

        expect(page).to have_current_path tasks_path, ignore_query: true
        expect(page).to have_content 'タスク名は30文字以内で入力してください'
      end
    end
  end

  describe 'タスク編集' do
    let!(:task) { create(:task) }

    context '編集ページの表示' do
      it '編集タスクがある場合、編集ページの表示に成功' do
        visit root_path

        expect(page).to have_link '編集'

        click_on '編集'

        expect(page).to have_current_path edit_task_path(task.id), ignore_query: true
        expect(page).to have_field 'task[title]'
        expect(page).to have_field 'task[content]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end

      it '編集タスクがない場合、該当するタスクがないと表示' do
        task.destroy

        visit edit_task_path(task.id)

        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end

    context '編集成功' do
      it '全て入力した場合、タスクの更新に成功' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        click_on '登録'

        expect(page).to have_current_path tasks_path, ignore_query: true
        expect(page).to have_content 'update_test'
        expect(page).to have_content 'update_content'
        expect(page).to have_content 'タスクの更新に成功しました。'
      end

      it '概要が未入力の場合、タスクの更新に成功' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: ''
        click_button '登録'

        expect(page).to have_current_path tasks_path, ignore_query: true
        expect(page).to have_content 'update_test'
        expect(page).to have_selector('td', text: '')
        expect(page).to have_content 'タスクの更新に成功しました。'
      end
    end

    context '編集失敗' do
      it 'タイトル名が未入力の場合、タスクの更新に失敗' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'update_content'
        click_button '登録'

        expect(page).to have_current_path task_path(task.id), ignore_query: true
        expect(page).to have_content 'タスク名を入力してください'
      end

      it '更新タスクがない場合、該当するタスクがないと表示' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        task.destroy
        click_button '登録'

        expect(page).to have_current_path root_path, ignore_query: true
        expect(page).to have_content '該当するリソースがありませんでした。'
      end
    end
  end

  describe 'タスク削除' do
    let!(:task) { create(:task) }

    it '削除タスクがある場合、タスクの削除に成功' do
      visit root_path

      expect(page).to have_link '削除'

      click_on '削除'

      expect(page).to have_current_path tasks_path, ignore_query: true
      expect(page).to have_content 'タスクの削除に成功しました。'
      expect(page).not_to have_content task.title
    end

    it '削除タスクがない場合、該当するリソースがないと表示' do
      visit root_path

      task.destroy
      click_on '削除'

      expect(page).to have_current_path root_path, ignore_query: true
      expect(page).to have_content '該当するリソースがありませんでした。'
    end
  end
end
