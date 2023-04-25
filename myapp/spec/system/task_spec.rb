require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:task) { create(:task) }

  describe 'タスク表示' do
    context '一覧' do
      it 'DBに保存されたデータがあれば一覧表示' do
        task_list = create_list(:task, 3)
        visit root_path

        expect(current_path).to eq root_path
        expect(page).to have_content task_list[0].id
        expect(page).to have_content task_list[0].title
        expect(page).to have_content task_list[0].content
        expect(page).to have_content task_list[1].id
        expect(page).to have_content task_list[1].title
        expect(page).to have_content task_list[1].content
        expect(page).to have_content task_list[2].id
        expect(page).to have_content task_list[2].title
        expect(page).to have_content task_list[2].content
        expect(page).to have_link '詳細'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
      end

      it 'DBに保存されたデータがなければ、新規登録ボタンのみ表示' do
        visit root_path

        expect(current_path).to eq root_path
        expect(page).to have_no_content task.id
        expect(page).to have_no_content task.title
        expect(page).to have_no_content task.content
        expect(page).to have_no_link '詳細'
        expect(page).to have_no_link '編集'
        expect(page).to have_no_link '削除'
        expect(page).to have_link '新規登録'
      end
    end

    context '詳細' do
      it '表示成功' do
        visit task_path(task.id)

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_link 'もどる'
      end

      it '表示失敗' do
        task.destroy

        visit task_path(task.id)

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するタスクがありませんでした。'
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
      expect(page).to have_button '登録'
      expect(page).to have_link 'もどる'
    end

    context '登録成功' do
      it '全て入力した場合、タスクの登録に成功' do
        visit new_task_path

        fill_in 'task[title]', with: 'test_title'
        fill_in 'task[content]', with: 'test_content'
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
        expect(page).to have_content 'タスクの登録に成功しました。'
      end

      it '概要が未入力の場合、タスクの登録に成功' do
        visit new_task_path

        fill_in 'task[title]', with: 'test'
        fill_in 'task[content]', with: ''
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'test'
        expect(page).to have_selector('td', text: '')
        expect(page).to have_content 'タスクの登録に成功しました。'
      end
    end

    context '登録失敗' do
      it 'タイトル名が未入力の場合、タスクの登録' do
        visit new_task_path

        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'test_content'
        click_button '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスクの登録に失敗しました。'
      end
    end
  end

  describe 'タスク編集' do
    let!(:task) { create(:task) }

    context '編集ページの表示' do
      it '表示成功' do
        visit root_path

        expect(page).to have_link '編集'

        click_on '編集'

        expect(current_path).to eq edit_task_path(task.id)
        expect(page).to have_field 'task[title]'
        expect(page).to have_field 'task[content]'
        expect(page).to have_button '登録'
        expect(page).to have_link 'もどる'
      end

      it '表示失敗' do
        task.destroy

        visit edit_task_path(task.id)

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するタスクがありませんでした。'
      end
    end

    context '編集成功' do
      it '全て入力した場合、タスクの更新に成功' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        click_on '登録'

        expect(current_path).to eq tasks_path
        expect(page).to have_content 'update_test'
        expect(page).to have_content 'update_content'
        expect(page).to have_content 'タスクの更新に成功しました。'
      end

      it '概要が未入力の場合、タスクの更新に成功' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: ''
        click_button '登録'

        expect(current_path).to eq tasks_path
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

        expect(current_path).to eq task_path(task.id)
        expect(page).to have_content 'タスクの更新に失敗しました。'
      end

      it '更新データない場合、該当するタスクがないと表示' do
        visit edit_task_path(task.id)

        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        task.destroy
        click_button '登録'

        expect(current_path).to eq root_path
        expect(page).to have_content '該当するタスクがありませんでした。'
      end
    end
  end

  describe 'タスク削除' do
    let!(:task) { create(:task) }
    it 'タスクの削除成功' do
      visit root_path

      expect(page).to have_link '削除'

      click_on '削除'

      expect(current_path).to eq tasks_path
      expect(page).to have_content 'タスクの削除に成功しました。'
      expect(page).not_to have_content task.title
    end

    it 'タスクの削除失敗' do
      visit root_path

      task.destroy
      click_on '削除'

      expect(current_path).to eq root_path
      expect(page).to have_content '該当するタスクがありませんでした。'
    end
  end
end
