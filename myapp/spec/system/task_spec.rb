require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:task) {create(:task)}

  describe 'ページ遷移確認' do
    context 'タスクの詳細ページへのアクセス' do
      it 'タスクの詳細ページへアクセスされる' do
        visit root_path
        visit task_path(task.id)
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_link 'もどる'
        expect(current_path).to eq task_path(task.id)
      end
    end

    context 'タスクの一覧ページへアクセス' do
      it 'タスクの一覧ページへアクセスされる' do
        task_list = create_list(:task, 3)
        visit root_path
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
        expect(current_path).to eq root_path
      end
    end

    context 'タスクの新規登録ページへのアクセス'do
      it  'タスクの新規登録ボタンを押すと新規登録ページにアクセスされる' do
        visit tasks_path
        click_on '新規登録'
        expect(current_path).to eq new_task_path
      end
    end
  end

  describe 'タスクの新規登録' do
    context '入力内容が正常' do
      it 'タスクの新規登録に成功する' do
        visit root_path
        click_on '新規登録'
        fill_in 'task[title]', with: 'test'
        fill_in 'task[content]', with: 'test_content'
        click_button  '登録'
        expect(page).to have_content 'test'
        expect(page).to have_content 'test_content'
        expect(page).to have_content 'タスクの登録に成功しました。'
        expect(current_path).to eq tasks_path
      end

      it 'タスクの新規登録は詳細の入力無しでも成功する' do
        visit root_path
        click_on '新規登録'
        fill_in 'task[title]', with: 'test'
        fill_in 'task[content]', with: ''
        click_button  '登録'
        expect(page).to have_content 'test'
        expect(page).to have_content ''
        expect(page).to have_content 'タスクの登録に成功しました。'
        expect(current_path).to eq tasks_path
      end
    end

    context 'タスク名が未入力' do
      it 'タスクの新規登録に失敗する' do
        visit root_path
        click_on '新規登録'
        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'test_content'
        click_button  '登録'
        expect(page).to have_content 'タスクの登録に失敗しました。'
        expect(current_path).to eq tasks_path
      end
    end
  end

  describe 'タスクの編集' do
    let!(:task) {create(:task)}

    context '入力内容が正常' do
      it 'タスクの編集更新に成功する' do
        visit root_path
        click_link '編集'
        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        click_button  '登録'
        expect(page).to have_content 'update_test'
        expect(page).to have_content 'update_content'
        expect(page).to have_content 'タスクの更新に成功しました。'
        expect(current_path).to eq tasks_path
      end

      it 'タスクの編集は詳細の入力無しでも成功する' do
        visit root_path
        click_link '編集'
        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: ''
        click_button  '登録'
        expect(page).to have_content 'update_test'
        expect(page).to have_content ''
        expect(page).to have_content 'タスクの更新に成功しました。'
        expect(current_path).to eq tasks_path
      end
    end

    context 'タスク名が未入力' do
      it 'タスクの編集更新に失敗する' do
        visit root_path
        click_link '編集'
        fill_in 'task[title]', with: ''
        fill_in 'task[content]', with: 'update_content'
        click_button  '登録'
        expect(page).to have_content 'タスクの更新に失敗しました。'
        expect(current_path).to eq task_path(task.id)
      end
    end
  end

  describe 'タスクの削除' do
    let!(:task) { create(:task) }

    context '正常にタスクを削除できる'
    it 'タスクの削除に成功する' do
      visit root_path
      click_link '削除'
      expect(page).to have_content 'タスクの削除に成功しました。'
      expect(current_path).to eq tasks_path
      expect(page).not_to have_content task.title
    end
  end

  describe '該当タスクが存在しなかった例外処理' do
    let!(:task) { create(:task) }

    context 'editメソッド呼び出しの時' do
      it '編集するタスクが存在しなかった例外処理' do
        visit root_path
        task.destroy
        expect{Task.find(task.id)}.to raise_error(ActiveRecord::RecordNotFound)
        click_link '編集'
        expect(current_path).to eq root_path
        expect(page).to have_content '該当するタスクがありませんでした。'
      end
    end

    context 'updateメソッド呼び出しの時' do
      it '更新するタスクが存在しなかった例外処理' do
        visit root_path
        click_link '編集'
        fill_in 'task[title]', with: 'update_test'
        fill_in 'task[content]', with: 'update_content'
        task.destroy
        expect{Task.find(task.id)}.to raise_error(ActiveRecord::RecordNotFound)
        click_button  '登録'
        expect(current_path).to eq root_path
        expect(page).to have_content '該当するタスクがありませんでした。'
      end
    end

    context 'destoryメソッド呼び出しの時' do
      it '削除するタスクが存在しなかった例外処理' do
        visit root_path
        task.destroy
        expect{Task.find(task.id)}.to raise_error(ActiveRecord::RecordNotFound)
        click_link '削除'
        expect(current_path).to eq root_path
        expect(page).to have_content '該当するタスクがありませんでした。'
      end
    end
    context 'showメソッドメソッド呼び出しの時' do
      it '詳細を見れるタスクが存在しなかった例外処理' do
        visit root_path
        task.destroy
        expect{Task.find(task.id)}.to raise_error(ActiveRecord::RecordNotFound)
        visit task_path(task.id)
        expect(current_path).to eq root_path
        expect(page).to have_content '該当するタスクがありませんでした。'
      end
    end
  end
end
