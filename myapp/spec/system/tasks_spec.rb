# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Test cases for Task :', type: :system do
  let!(:testuser) { FactoryBot.create(:user) }
  let(:tasks_mock) { double('tasks mock') }
  let!(:labels) { FactoryBot.create_list(:label, 5) { |label, index| label.name = "Label#{index}" } }

  before do
    visit login_path
    fill_in 'session_email', with: 'test@test.com'
    fill_in 'session_password', with: 'password'
    click_button 'ログイン'
  end

  describe 'In task list page' do
    context 'when there is no task,' do
      before do
        # 一覧画面を開く
        visit tasks_path
      end

      it 'does not show any task' do
        # 正しい情報が表示されていること
        expect(page).to have_content 'タスク一覧'
        expect(Task.count).to eq 0
      end
    end

    context 'when there are tasks,' do
      before do
        FactoryBot.create(:task, user: testuser)
        FactoryBot.create(:task, user: testuser, labels: labels, title: 'Spec2', description: 'test2', end_date: Time.new(2023, 11, 1, 10, 30),
                                 status: 2)

        # 一覧画面を開く
        visit tasks_path
      end

      it 'shows correct result when there are multiple tasks' do
        # 正しい情報が表示されていること
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content 'Spec'
        expect(page).to have_content 'test'
        expect(page).to have_content '2022年12月07日(水) 10時30分00秒'
        expect(page).to have_content '着手中'
        expect(page).to have_content 'Spec2'
        expect(page).to have_content 'test2'
        expect(page).to have_content '2023年11月01日(水) 10時30分00秒'
        expect(page).to have_content '完了'
      end

      context 'when sort,' do
        it 'sorts correctly after push sort button: latest' do
          click_link '新しい順'

          expect(page).to have_content 'タスク一覧'
          # 正規表現で並び順をチェック
          expect(page.text.to_s).to match(/Spec2[\s\S]*Spec/)
        end

        it 'sorts correctly after push sort button: expiring' do
          click_link '終了期限が近い順'

          expect(page).to have_content 'タスク一覧'
          # 正規表現で並び順をチェック
          expect(page.text).to match(/Spec[\s\S]*Spec2/)
        end
      end

      context 'when search,' do
        it 'shows correctly when search by title' do
          fill_in 'keyword', with: 'Spec2'

          click_button '検索'

          expect(page).to have_content 'Spec2'
          # 一番目のタスクが存在しないこと
          expect(page).not_to have_content '2022年12月07日(水) 10時30分00秒'
        end

        it 'shows correctly when search by status' do
          choose '着手中'

          click_button '検索'

          expect(page).to have_content '2022年12月07日(水) 10時30分00秒'
          expect(page).not_to have_content 'spec2'
        end

        it 'shows correctly when search by labels' do
          select 'Label1', from: 'label_id'

          click_button '検索'

          expect(page).to have_content 'Spec2'
          expect(page).not_to have_content '2022年12月07日(水) 10時30分00秒'
        end

        it 'shows correctly when search by both title and status' do
          fill_in 'keyword', with: 'Spec2'
          choose '着手中'
          select 'Label1', from: 'label_id'

          click_button '検索'

          expect(page).not_to have_content 'spec2'

          fill_in 'keyword', with: 'Spec2'
          choose '完了'

          click_button '検索'

          expect(page).to have_content 'Spec2'
          expect(page).not_to have_content '2022年12月07日(水) 10時30分00秒'
        end
      end

      context 'test pagenation' do
        before do
          # status=0 のレコードを15個作成する
          FactoryBot.create_list(:task, 15, user: testuser, status: 0) { |task, index| task.title = "Spec#{index}" }
          # status=1 のレコードを10個作成する
          FactoryBot.create_list(:task, 5, user: testuser, status: 1) { |task, index| task.title = "Spec#{index}" }
          # 一覧画面を開く
          visit tasks_path
        end

        it 'pagenation works' do
          expect(page).to have_content '1 2 3 次 › 最後 »'
        end

        it 'pagenation works after search' do
          choose '未着手'
          click_button '検索'

          expect(page).to have_content '1 2 次 › 最後 »'
        end
      end
    end

    context 'when error,' do
      before do
        allow(Task).to receive(:search).and_raise(RuntimeError)
        # 一覧画面を開く
        visit tasks_path
      end

      it 'redirected to 500 error page' do
        expect(page).to have_content '伍〇〇'
      end
    end
  end

  describe 'In new task page' do
    context 'when success,' do
      it 'create task correctly' do
        # 新規画面を開く
        visit new_task_path

        # 新規画面が開いてること（titleが空白になってる）
        expect(page).to have_content '新規登録'
        expect(find_field('task_title').text).to be_blank
        expect(page).to have_field 'task_description', with: ''

        # titleとdescriptionを入力
        fill_in 'task_title', with: 'Spec test new task'
        fill_in 'task_description', with: 'Spec test new task description'
        fill_in 'task_end_date', with: Time.new(2023, 11, 1, 10, 30)
        select '完了', from: 'task_status'

        # 登録
        click_button 'タスクを登録する'

        # 正しく登録されていること
        expect(page).to have_content 'タスクを作成しました'
        expect(page).to have_content 'タスク詳細'
        expect(page).to have_content 'Spec test new task'
        expect(page).to have_content 'Spec test new task description'
        expect(page).to have_content '2023年11月01日(水) 10時30分00秒'
        expect(page).to have_content '完了'
      end
    end

    context 'when DB insert fail,' do
      before do
        new_task_mock = Task.new

        allow(Task).to receive(:new).and_return(new_task_mock)
        allow(new_task_mock).to receive(:save).and_return(false)
      end

      it 'shows error message' do
        # 新規画面を開く
        visit new_task_path

        # 新規画面が開いてること（titleが空白になってる）
        expect(page).to have_content '新規登録'
        expect(find_field('task_title').text).to be_blank
        expect(page).to have_field 'task_description', with: ''

        # titleとdescriptionを入力
        fill_in 'task_title', with: 'Spec test new task'
        fill_in 'task_description', with: 'Spec test new task description'

        # 登録
        click_button 'タスクを登録する'

        # 正しく登録されていること
        expect(page).to have_content '作成に失敗しました'
        expect(page).to have_content '新規登録'
      end
    end

    context 'when validation error,' do
      before do
        # 新規画面を開く
        visit new_task_path

        # 新規画面が開いてること（titleが空白になってる）
        expect(page).to have_content '新規登録'
        expect(find_field('task_title').text).to be_blank
        expect(page).to have_field 'task_description', with: ''
      end

      it 'shows blank error' do
        # 登録
        click_button 'タスクを登録する'

        # 正しく登録されていること
        expect(page).to have_content '作成に失敗しました'
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content '新規登録'
      end

      it 'shows length error' do
        fill_in 'task_title', with: Faker::Lorem.characters(number: 41)
        fill_in 'task_description', with: Faker::Lorem.characters(number: 501)

        # 登録
        click_button 'タスクを登録する'

        # 正しく登録されていること
        expect(page).to have_content '作成に失敗しました'
        expect(page).to have_content 'タイトルは40文字以内で入力してください'
        expect(page).to have_content '詳細は500文字以内で入力してください'
        expect(page).to have_content '新規登録'
      end
    end

    context 'when system error,' do
      before do
        new_task_mock = Task.new

        allow(Task).to receive(:new).and_return(new_task_mock)
        allow(new_task_mock).to receive(:save).and_raise(RuntimeError)
      end

      it 'shows error message' do
        # 新規画面を開く
        visit new_task_path

        # 新規画面が開いてること（titleが空白になってる）
        expect(page).to have_content '新規登録'
        expect(find_field('task_title').text).to be_blank
        expect(page).to have_field 'task_description', with: ''

        # titleとdescriptionを入力
        fill_in 'task_title', with: 'Spec test new task'
        fill_in 'task_description', with: 'Spec test new task description'

        # 登録
        click_button 'タスクを登録する'

        # エラーページが表示されてること
        expect(page).to have_content '伍〇〇'
      end
    end
  end

  describe 'In task detail page' do
    let!(:task) { FactoryBot.create(:task, user: testuser) }

    context 'when success,' do
      it 'shows result correctly' do
        # 詳細画面を開く
        visit task_path(task)

        # 正しい情報が表示されていること
        expect(page).to have_content 'タスク詳細'
        expect(page).to have_content 'Spec'
        expect(page).to have_content 'test'
        expect(page).to have_content '2022年12月07日(水) 10時30分00秒'
        expect(page).to have_content '着手中'
      end
    end

    context 'when not found,' do
      it 'shows 404 page' do
        visit task_path('not_exist_id')
        expect(page).to have_content '肆〇肆'
      end
    end

    context 'when error,' do
      before do
        allow(User).to receive(:find_by).and_return(testuser)
        allow(testuser).to receive(:tasks).and_raise(RuntimeError)
      end

      it 'shows 500 page' do
        visit task_path(task)
        expect(page).to have_content '伍〇〇'
      end
    end
  end

  describe 'In edit task page:' do
    let!(:task) { FactoryBot.create(:task, user: testuser) }

    context 'when success,' do
      it 'works correctly' do
        # タスク編集画面を開く
        visit edit_task_path(task)

        # titleとdescriptionが正しく表示されること
        expect(page).to have_content 'タスク編集'
        expect(page).to have_field 'task_title', with: 'Spec'
        expect(page).to have_field 'task_description', with: 'test'

        # titleとdescriptionを入力する
        fill_in 'task_title', with: 'Spec first task'
        fill_in 'task_description', with: 'Spec first task description'
        fill_in 'task_end_date', with: Time.new(2023, 11, 1, 10, 30)
        select '完了', from: 'task_status'

        # 更新実行
        click_button 'タスクを更新する'

        # 正しく更新されていること
        expect(page).to have_content 'タスクを更新しました'
        expect(page).to have_content 'タスク詳細'
        expect(page).to have_content 'Spec first task'
        expect(page).to have_content 'Spec first task description'
        expect(page).to have_content '2023年11月01日(水) 10時30分00秒'
        expect(page).to have_content '完了'
      end
    end

    context 'when DB update fail,' do
      before do
        allow(User).to receive(:find_by).and_return(testuser)
        allow(testuser).to receive(:tasks).and_return(tasks_mock)
        allow(tasks_mock).to receive(:find).and_return(task)
        allow(task).to receive(:update).and_return(false)
      end

      it 'shows error message' do
        # タスク編集画面を開く
        visit edit_task_path(task)

        # titleとdescriptionが正しく表示されること
        expect(page).to have_content 'タスク編集'
        expect(page).to have_field 'task_title', with: 'Spec'
        expect(page).to have_field 'task_description', with: 'test'

        # titleとdescriptionを入力する
        fill_in 'task_title', with: 'Spec first task'
        fill_in 'task_description', with: 'Spec first task description'

        # 更新実行
        click_button 'タスクを更新する'

        # 失敗していること
        expect(page).to have_content '更新に失敗しました。'
        expect(page).to have_content 'タスク編集'
      end
    end

    context 'when not found,' do
      it 'shows 404 page' do
        visit edit_task_path('not_exist_id')
        expect(page).to have_content '肆〇肆'
      end
    end

    context 'when validation error,' do
      before do
        # タスク編集画面を開く
        visit edit_task_path(task)

        # titleとdescriptionが正しく表示されること
        expect(page).to have_content 'タスク編集'
        expect(page).to have_field 'task_title', with: 'Spec'
        expect(page).to have_field 'task_description', with: 'test'
      end

      it 'shows blank error' do
        # titleとdescriptionを空にする
        fill_in 'task_title', with: ''
        fill_in 'task_description', with: ''

        # 更新実行
        click_button 'タスクを更新する'

        # 正しく登録されていること
        expect(page).to have_content '更新に失敗しました。'
        expect(page).to have_content 'タイトルを入力してください'
        expect(page).to have_content 'タスク編集'
      end

      it 'shows length error' do
        # titleとdescriptionを文字数オーバーで入力する
        fill_in 'task_title', with: Faker::Lorem.characters(number: 41)
        fill_in 'task_description', with: Faker::Lorem.characters(number: 501)

        # 更新実行
        click_button 'タスクを更新する'

        # 正しく登録されていること
        expect(page).to have_content '更新に失敗しました。'
        expect(page).to have_content 'タイトルは40文字以内で入力してください'
        expect(page).to have_content '詳細は500文字以内で入力してください'
        expect(page).to have_content 'タスク編集'
      end
    end

    context 'when system error,' do
      before do
        allow(User).to receive(:find_by).and_return(testuser)
        allow(testuser).to receive(:tasks).and_raise(RuntimeError)
      end

      it 'shows 500 page' do
        visit edit_task_path(task)
        expect(page).to have_content '伍〇〇'
      end
    end
  end

  describe 'For delete task button,', js: true do
    let!(:task) { FactoryBot.create(:task, user: testuser) }

    context 'when success,' do
      it 'works correctly' do
        visit task_path(task)
        click_link '削除'
        expect do
          expect(page.accept_confirm).to eq '本当に削除しますか？'
          expect(page).to have_content '正常に削除しました'
        end.to change(Task, :count).by(-1)
        is_expected.not_to have_content 'Spec'
        is_expected.not_to have_content 'test'
      end
    end

    context 'when DB delete fail,' do
      before do
        visit task_path(task)

        allow(User).to receive(:find_by).and_return(testuser)
        allow(testuser).to receive(:tasks).and_return(tasks_mock)
        allow(tasks_mock).to receive(:find).and_return(task)
        allow(task).to receive(:destroy).and_return(false)
      end

      it 'shows error message' do
        visit task_path(task)
        click_link '削除'
        expect do
          expect(page.accept_confirm).to eq '本当に削除しますか？'
          expect(page).to have_content '削除失敗しました。'
        end.to change(Task, :count).by(0)
        is_expected.not_to have_content 'Spec'
        is_expected.not_to have_content 'test'
      end
    end

    context 'when not found,' do
      before do
        visit task_path(task)

        allow(User).to receive(:find_by).and_return(testuser)
        allow(testuser).to receive(:tasks).and_raise(ActiveRecord::RecordNotFound)
      end

      it 'shows error message' do
        click_link '削除'
        expect do
          expect(page.accept_confirm).to eq '本当に削除しますか？'
          expect(page).to have_content '肆〇肆'
        end.to change(Task, :count).by(0)
      end
    end

    context 'when error,' do
      before do
        visit task_path(task)

        allow(User).to receive(:find_by).and_return(testuser)
        allow(testuser).to receive(:tasks).and_return(tasks_mock)
        allow(tasks_mock).to receive(:find).and_return(task)
        allow(task).to receive(:destroy).and_raise(RuntimeError)
      end

      it 'shows error message' do
        click_link '削除'
        expect do
          expect(page.accept_confirm).to eq '本当に削除しますか？'
          expect(page).to have_content '伍〇〇'
        end.to change(Task, :count).by(0)
      end
    end
  end
end
