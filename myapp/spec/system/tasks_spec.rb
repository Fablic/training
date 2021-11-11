# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks', type: :system do
  let!(:user) { create(:generic_user) }
  let!(:admin) { create(:admin) }

  describe 'Index Page' do
    let!(:task_list) do
      create_list(:task, 4, created_by: user.id)
    end

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit root_path
    end

    it 'ui elements are present' do
      expect(page).to have_content 'Task-u-ten'
      expect(page).to have_selector(:id, 'add_task_btn')
    end

    it 'table elements are present' do
      within('#task_list') do
        expect(page).to have_content 'ステータス'
        expect(page).to have_content 'タスク名'
        expect(page).to have_content '開始日'
        expect(page).to have_content '終了日'
        expect(page).to have_content '作成日'

        expect(page).to have_content '詳細'
        expect(page).to have_content '編集'
        expect(page).to have_content '削除'
      end
    end

    it 'first and last items are present' do
      expect(page).to have_content task_list.first.name
      expect(page).to have_content task_list.last.name

      expect(page).to have_content I18n.l task_list.first.finished_at.to_date
      expect(page).to have_content I18n.l task_list.last.finished_at.to_date
    end

    # check navigation links
    it 'moves to new page' do
      find('#add_task_btn').click
      expect(page).to have_content '新規タスク'
      expect(page).to have_content '戻る'
      click_on '登録する'
    end

    it 'moves to show page' do
      find('#task_list > tbody:nth-child(2) > tr:nth-child(1)').click_on '詳細'
      expect(page).to have_content task_list[3].name
      expect(page).to have_content '詳細タスク'
      expect(page).to have_content '戻る'
      expect(page).to have_content '編集'
    end

    it 'moves to edit page' do
      find('#task_list > tbody:nth-child(2) > tr:nth-child(1)').click_on '編集'
      expect(page).to have_field('task_name', with: task_list[3].name)
      expect(page).to have_field('task_description', with: task_list[3].description)
      expect(page).to have_content '編集タスク'
      expect(page).to have_content 'タスク名'
      expect(page).to have_content '戻る'
    end
  end

  describe 'Sorting' do
    let!(:task_list) {
      create_list(:task, 4, created_by: user.id) do |task, i|
        task.finished_at = i.days.from_now.strftime('%Y-%m-%d')
        task.save
      end
    }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit root_path
    end

    it 'can change sort order of created_at DESC' do
      expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content task_list[3].name
      expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content task_list[0].name

      click_on '作成日' # sort ASC

      expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content task_list[0].name
      expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content task_list[3].name
    end

    it 'can change sort order by finished_at' do
      click_on '終了日'

      expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content task_list[0].name
      expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content task_list[3].name

      click_on '終了日'

      expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(1)')).to have_content task_list[3].name
      expect(find('#task_list > tbody:nth-child(2) > tr:nth-child(4)')).to have_content task_list[0].name
    end
  end

  describe 'New Page' do
    let(:params) {
      { name: 'this is a new task',
        description: 'description for new task' }
    }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit new_task_path
    end

    context 'with Normal cases' do
      it 'check ui elements' do
        expect(page).to have_content '新規タスク'
      end

      it 'add pending task successfully' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[description]', with: params[:description]
        fill_in 'task[finished_at]', with: Time.zone.today.strftime('%Y-%m-%d')
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
      end

      it 'add started task successfully' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[description]', with: params[:description]
        fill_in 'task[finished_at]', with: Time.zone.today.strftime('%Y-%m-%d')
        select '着手', from: 'task[status]'
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
        expect(page).to have_content '詳細タスク'
        expect(page).to have_content 'ステータス 着手'
      end

      it 'add finished task successfully' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[description]', with: params[:description]
        fill_in 'task[finished_at]', with: Time.zone.today.strftime('%Y-%m-%d')
        select '完了', from: 'task[status]'
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
        expect(page).to have_content '詳細タスク'
        expect(page).to have_content 'ステータス 完了'
      end

      it 'start & finished in future' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[started_at]', with: 5.days.from_now.strftime('%Y-%m-%d')
        fill_in 'task[finished_at]', with: 10.days.from_now.strftime('%Y-%m-%d')

        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
      end

      it 'start in past , end  in future' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[started_at]', with: 5.days.ago.strftime('%Y-%m-%d')
        fill_in 'task[finished_at]', with: 10.days.from_now.strftime('%Y-%m-%d')
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
      end
    end

    context 'with Validation Error case' do
      it 'blank name' do
        click_on '登録する'
        expect(page).to have_content 'タスク名を入力してください'
      end

      it 'finished_at less than started_at' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[started_at]', with: 15.days.from_now.strftime('%Y-%m-%d')
        fill_in 'task[finished_at]', with: 5.days.from_now.strftime('%Y-%m-%d')
        click_on '登録する'
        expect(page).to have_content '終了日を開始日より前にすることはできません'
      end

      it 'invalid date format' do
        fill_in 'task[name]', with: params[:name]

        fill_in 'task[finished_at]', with: 'hoge'
        click_on '登録する'
        expect(page).to have_content '無効な日付です'
      end

      it 'invalid date ' do
        fill_in 'task[name]', with: params[:name]

        fill_in 'task[finished_at]', with: '2021-02-31'
        click_on '登録する'
        expect(page).to have_content '無効な日付です'
      end
    end
  end

  describe 'Filtered index' do
    let!(:admin_list) { create_list(:task, 4, created_by: admin.id) }
    let!(:normal_list) { create_list(:task, 4, created_by: user.id) }

    context 'with admin' do
      it ' sees all items' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
        visit root_path
        expect(page).to have_content admin_list[0].name
        expect(page).to have_content admin_list[3].name
        expect(page).to have_content normal_list[0].name
        expect(page).to have_content normal_list[3].name
      end
    end

    context 'with non-admin' do
      it ' sees only own tasks' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        visit root_path
        expect(page).not_to have_content admin_list[0].name
        expect(page).not_to have_content admin_list[3].name
        expect(page).to have_content normal_list[0].name
        expect(page).to have_content normal_list[3].name
      end
    end
  end
end
