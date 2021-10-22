# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tasks', type: :system do
  let!(:user) { create(:generic_user) }

  describe 'Index Page' do
    let!(:task_list) do
      create_list(:task, 4, created_by: user.id)
    end

    before do
      visit root_path
    end

    it 'ui elements are present' do
      expect(page).to have_content 'Task-u-ten'
      expect(page).to have_content '新規 タスク'
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
      click_on '新規 タスク'
      expect(page).to have_content '新規タスク'
      expect(page).to have_content '戻る'
      click_on '登録する'
    end

    it 'moves to show page' do
      find('tr:nth-child(2)').click_on '詳細'
      expect(page).to have_content task_list[1].name
      expect(page).to have_content '詳細タスク'
      expect(page).to have_content '戻る'
      expect(page).to have_content '編集'
    end

    it 'moves to edit page' do
      find('tr:nth-child(2)').click_on '編集'
      expect(page).to have_field('task_name', with: task_list[1].name)
      expect(page).to have_field('task_description', with: task_list[1].description)
      expect(page).to have_content '編集タスク'
      expect(page).to have_content 'タスク名'
      expect(page).to have_content '戻る'
      expect(page).to have_content '詳細'
    end
  end

  describe 'New Page' do
    let(:params) {
      { name: 'this is a new task',
        description: 'description for new task' }
    }

    before do
      visit new_task_path
    end

    context 'with Normal cases' do
      it 'check ui elements' do
        expect(page).to have_content '新規タスク'
      end

      it 'add pending task successfully' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[description]', with: params[:description]
        fill_in 'task[created_by]', with: user.id
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
      end

      it 'add started task successfully' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[description]', with: params[:description]
        fill_in 'task[created_by]', with: user.id
        select '着手', from: 'task[status]'
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
        expect(page).to have_content '詳細タスク'
        expect(page).to have_content 'ステータス 着手'
      end

      it 'add finished task successfully' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[description]', with: params[:description]
        fill_in 'task[created_by]', with: user.id
        select '完了', from: 'task[status]'
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
        expect(page).to have_content '詳細タスク'
        expect(page).to have_content 'ステータス 完了'
      end

      it 'start & finished in future' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[created_by]', with: user.id
        select Time.zone.now.year + 2, from: 'task[finished_at(1i)]'
        select Time.zone.now.year + 1, from: 'task[started_at(1i)]'
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
      end

      it 'start in past , end  in future' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[created_by]', with: user.id
        select Time.zone.now.year + 1, from: 'task[finished_at(1i)]'
        select Time.zone.now.year - 1, from: 'task[started_at(1i)]'
        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました.'
      end
    end

    context 'with Validation Error case' do
      it 'blank name and owner' do
        click_on '登録する'
        expect(page).to have_content 'オーナーを入力してください'
        expect(page).to have_content 'オーナーは数値で入力してください'
        expect(page).to have_content 'タスク名を入力してください'
        expect(page).to have_content 'Userを入力してください'
      end

      it 'owner does not exist' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[created_by]', with: user.id + 2134
        click_on '登録する'
        expect(page).to have_content 'Userを入力してください'
      end

      it 'owner is not integer' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[created_by]', with: 'hoge'
        click_on '登録する'
        expect(page).to have_content 'オーナーは数値で入力してください'
      end

      it 'finished_at less than started_at' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[created_by]', with: user.id
        select Time.zone.now.year + 1, from: 'task[finished_at(1i)]'
        select Time.zone.now.year + 2, from: 'task[started_at(1i)]'
        click_on '登録する'
        expect(page).to have_content '終了日を開始日より前にすることはできません'
      end

      it 'finished_at is in the past' do
        fill_in 'task[name]', with: params[:name]
        fill_in 'task[created_by]', with: user.id
        select Time.zone.now.year - 1, from: 'task[finished_at(1i)]'
        select Time.zone.now.year - 2, from: 'task[started_at(1i)]'
        click_on '登録する'
        expect(page).to have_content '終了日を今日より前にすることはできません'
      end
    end
  end
end
