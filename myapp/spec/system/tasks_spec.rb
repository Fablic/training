# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Task', type: :system do
  before do
    create(:user)
  end

  describe '#index' do
    before do
      visit root_path
    end

    it 'display default item' do
      expect(page).to have_link '新規作成'
    end

    it 'go to New Task page' do
      click_on '新規作成'
      expect(page).to have_current_path new_task_path, ignore_query: true
    end

    context 'when user has tasks' do
      before do
        create(:task, name: 'test1')
        create(:task, name: 'test2')
        create(:task, name: 'test3')
        visit current_path
      end

      it "return user's task" do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_link 'test1'
        expect(page).to have_link 'test2'
        expect(page).to have_link 'test3'
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
      end

      it 'tasks displayed in DESC order of creation date' do
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[test3 test2 test1]
        end
      end
    end

    context 'when push sort button' do
      before do
        create(:task, name: 'test1', limit: Time.new(2022, 1, 10).in_time_zone, created_at: Time.new(2021, 12, 1).in_time_zone)
        create(:task, name: 'test2', limit: Time.new(2022, 1, 2).in_time_zone, created_at: Time.new(2021, 12, 2).in_time_zone)
        create(:task, name: 'test3', limit: Time.new(2022, 1, 30).in_time_zone, created_at: Time.new(2021, 12, 3).in_time_zone)
        visit current_path
      end

      it 'sorted by creation date' do
        click_on '作成日時'
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[test1 test2 test3]
        end
      end

      it 'sorted in asc order by limit date' do
        click_on '期限'
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[test2 test1 test3]
        end
      end

      it 'sorted in desc order by limit date' do
        click_on '期限'
        click_on '期限'
        within '.tasks' do
          task_titles = all('.task-title').map(&:text)
          expect(task_titles).to eq %w[test3 test1 test2]
        end
      end
    end

    context 'when use search function' do
      before do
        create(:task, name: '洗濯1', description: 'コインランドリーに行く', priority: 'Low', status: 'TODO', limit: Time.new(2022, 1, 10).in_time_zone, created_at: Time.new(2021, 12, 1).in_time_zone)
        create(:task, name: '洗濯2', description: 'クリーニング屋に行く', priority: 'High', status: 'DONE', limit: Time.new(2022, 1, 10).in_time_zone, created_at: Time.new(2021, 12, 1).in_time_zone)
        create(:task, name: '掃除', description: '洗面所掃除する', priority: 'Normal', status: 'IN_PROGRESS', limit: Time.new(2022, 1, 2).in_time_zone, created_at: Time.new(2021, 12, 2).in_time_zone)
        create(:task, name: '買い物', description: '柔軟剤買う', priority: 'High', status: 'DONE',  limit: Time.new(2022, 1, 30).in_time_zone, created_at: Time.new(2021, 12, 3).in_time_zone)
        visit current_path
      end

      it 'can search using the keyword' do # rubocop:disable RSpec/MultipleExpectations
        fill_in 'keyword', with: '洗濯'
        click_on '検索'
        expect(page).to have_content '洗濯1'
        expect(page).to have_content '洗濯2'
        expect(page).not_to have_content '掃除'
        expect(page).not_to have_content '買い物'
      end

      it 'can search using status' do # rubocop:disable RSpec/MultipleExpectations
        select '着手中', from: 'status'
        click_on '検索'
        expect(page).not_to have_content '洗濯1'
        expect(page).not_to have_content '洗濯2'
        expect(page).to have_content '掃除'
        expect(page).not_to have_content '買い物'
      end

      it 'can search using keyword and status' do # rubocop:disable RSpec/MultipleExpectations
        fill_in 'keyword', with: '洗濯'
        select '未着手', from: 'status'
        click_on '検索'
        expect(page).to have_content '洗濯1'
        expect(page).not_to have_content '洗濯2'
        expect(page).not_to have_content '掃除'
        expect(page).not_to have_content '買い物'
      end
    end

    context 'when number of tasks is more than 10' do
      before do
        create_list(:task, 11, :taskn)
        visit current_path
      end

      it 'displayed pagination' do
        expect(page).to have_content '最後'
      end
    end

    context 'when number of tasks is less than 10' do
      before do
        create_list(:task, 10, :taskn)
        visit current_path
      end

      it 'did not display pagination' do
        expect(page).not_to have_content '最後'
      end
    end
  end

  describe '#show' do
    let(:task) { create(:task, name: 'テストタスク', description: 'テストのタスク', priority: 1, status: 1, limit: '2022-6-20'.to_date, user_id: 1) }

    before do
      visit task_path(task)
    end

    it 'return task info' do # rubocop:disable RSpec/MultipleExpectations
      expect(page).to have_content 'テストタスク'
      expect(page).to have_content 'テストのタスク'
      expect(page).to have_content '未着手'
      expect(page).to have_content '低い'
      expect(page).to have_content I18n.l('2022-6-20'.to_date)
    end

    context 'when user click Edit' do
      it 'return edit task form' do
        click_on '編集'
        expect(page).to have_current_path edit_task_path(task), ignore_query: true
      end
    end

    context 'when user click Delete' do
      it 'delete task' do
        expect {
          click_on '削除'
        }.to change(Task, :count).by(-1)
      end

      it 'display delete success message' do
        click_on '削除'
        expect(page).to have_content 'Delete Task!!'
      end
    end

    context 'when user click Home' do
      it 'go to roog page' do
        click_on '一覧へ'
        expect(page).to have_current_path root_path, ignore_query: true
      end
    end
  end

  describe '#new' do
    before do
      visit new_task_path
    end

    context 'when user go to this page' do
      it 'display blank task form' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'タスク名'
        expect(page).to have_field '詳細'
        expect(page).to have_field '期限'
        expect(page).to have_field '状態'
        expect(page).to have_field '優先度'
      end
    end
  end

  describe '#edit' do
    let(:task) { create(:task) }

    before do
      visit edit_task_path(task)
    end

    context 'when user go to this page' do
      it 'display task form' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'タスク名', with: task.name
        expect(page).to have_field '詳細', with: task.description
        expect(page).to have_field '期限', with: task.limit
        expect(page).to have_field '状態', with: task.status
        expect(page).to have_field '優先度', with: task.priority
      end
    end
  end

  describe '#create' do
    before do
      visit new_task_path
    end

    context 'when user go to Add task page' do
      it 'display brank form' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'タスク名'
        expect(page).to have_field '詳細'
        expect(page).to have_field '期限'
        expect(page).to have_field '状態'
        expect(page).to have_field '優先度'
      end
    end

    context 'when user input task' do
      before do
        fill_in 'タスク名', with: '散歩'
        fill_in '詳細', with: '多摩川を歩く'
        fill_in '期限', with: '2022-06-20'
        select '未着手', from: '状態'
        select '低い', from: '優先度'
      end

      it 'display input task info' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'タスク名', with: '散歩'
        expect(page).to have_field '詳細', with: '多摩川を歩く'
        expect(page).to have_field '期限', with: '2022-06-20'
        expect(page).to have_field '状態', with: 'TODO'
        expect(page).to have_field '優先度', with: 'Low'
      end

      context 'when user click "Create Task" button' do
        it 'go to Task detail page' do # rubocop:disable RSpec/MultipleExpectations
          click_on '作成'
          expect(page).to have_content '散歩'
          expect(page).to have_content '多摩川を歩く'
          expect(page).to have_content I18n.l('2022-06-20'.to_date)
          expect(page).to have_content '未着手'
          expect(page).to have_content '低い'
        end
      end
    end
  end

  describe '#update' do
    let(:task) { create(:task) }

    before do
      visit edit_task_path(task)
    end

    context 'when user edit task form correctly' do
      before do
        fill_in 'タスク名', with: '運動'
        fill_in '詳細', with: '多摩川を走る'
        fill_in '期限', with: '2022-06-20'
        select '着手中', from: '状態'
        select '普通', from: '優先度'
      end

      it 'display new task info' do # rubocop:disable RSpec/MultipleExpectations
        expect(page).to have_field 'タスク名', with: '運動'
        expect(page).to have_field '詳細', with: '多摩川を走る'
        expect(page).to have_field '期限', with: '2022-06-20'
        expect(page).to have_field '状態', with: 'IN_PROGRESS'
        expect(page).to have_field '優先度', with: 'Normal'
      end

      context 'when user click "Update Task" button' do
        it 'go to Task detail page' do # rubocop:disable RSpec/MultipleExpectations
          click_on '更新'
          expect(page).to have_content '運動'
          expect(page).to have_content '多摩川を走る'
          expect(page).to have_content I18n.l('2022-06-20'.to_date)
          expect(page).to have_content '着手中'
          expect(page).to have_content '普通'
          expect(page).to have_content 'Edit Task!!'
        end
      end
    end

    context 'when user edit task form incorrectly' do
      before do
        fill_in 'タスク名', with: ''
        fill_in '詳細', with: '多摩川を走る'
        fill_in '期限', with: '2022-06-20'
        select '着手中', from: '状態'
        select '普通', from: '優先度'
      end

      it 'unable to complete editing (because name is blank)' do
        click_on '更新'
        expect(page).to have_content 'Failed'
      end
    end
  end

  describe '#destroy' do
    before do
      create(:task)
      visit root_path
    end

    context 'when the deletion process success' do
      it 'delete task' do
        expect {
          click_on '削除'
        }.to change(Task, :count).by(-1)
      end

      it 'display delete success message' do
        click_on '削除'
        expect(page).to have_content 'Delete Task!!'
      end
    end

    context 'when the deletion process fails' do
      before do
        allow_any_instance_of(Task).to receive(:destroy).and_return(false)
      end

      it 'display delete failed message' do
        click_on '削除'
        expect(page).to have_content 'Failed'
      end
    end
  end
end
