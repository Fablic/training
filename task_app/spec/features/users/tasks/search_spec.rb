# frozen_string_literal: true

# 各ユーザのタスク一覧画面に関するspec

require 'rails_helper'

feature 'タスク検索機能', type: :feature do
  let!(:user) { FactoryBot.create(:user, role: :admin) }
  let!(:label1) { create(:label, name: 'Ruby', user: user) }
  let!(:label2) { create(:label, name: 'PHP', user: user) }
  let!(:label3) { create(:label, name: 'Python', user: user) }
  let!(:tasks) {
    [
      FactoryBot.create(
        :task,
        name: 'タスク1',
        labels: [label1, label2],
        due_date: '20190203',
        priority: :middle,
        status: :in_progress,
        created_at: Time.zone.now,
        user: user,
      ),

      FactoryBot.create(
        :task,
        name: 'タスク2',
        labels: [label1, label3],
        due_date: '20190209',
        priority: :high,
        status: :to_do,
        created_at: 1.day.ago,
        user: user,
      ),
      FactoryBot.create(
        :task,
        name: 'task3',
        labels: [label2, label3],
        due_date: '20190206',
        priority: :low,
        status: :in_progress,
        created_at: 2.days.ago,
        user: user,
      ),

      FactoryBot.create(
        :task,
        name: 'ラスク4',
        labels: [label1, label2, label3],
        due_date: '20190212',
        priority: :low,
        status: :in_progress,
        created_at: 3.days.ago,
        user: user,
      ),
    ]
  }

  before do
    login(user, tasks_admin_user_path(user))
    fill_in 'name', with: task_name
    select status, from: 'status'
    select label, from: 'label'
    click_on('検索')
  end

  context '「タスク」で名前検索したとき' do
    let(:task_name) { 'タスク' }
    let(:status) { '指定しない' }
    let(:label) { '指定しない' }

    scenario '検索結果は2件' do
      expect(page.all('tbody tr').size).to eq 2
      expect(page).to have_content('タスク1', count: 1)
      expect(page).to have_content('タスク2', count: 1)
      expect(find_field('name').value).to eq 'タスク'
    end
  end

  context '「hoge」で名前検索したとき' do
    let(:task_name) { 'hoge' }
    let(:status) { '指定しない' }
    let(:label) { '指定しない' }

    scenario '検索結果は0件' do
      expect(page.all('tbody tr').size).to eq 0
      expect(find_field('name').value).to eq 'hoge'
    end
  end

  context '「着手中」でステータス検索したとき' do
    let(:task_name) { '' }
    let(:status) { '着手中' }
    let(:label) { '指定しない' }

    scenario '検索結果は3件' do
      expect(page.all('tbody tr').size).to eq 3
      expect(page).to have_content('タスク1', count: 1)
      expect(page).to have_content('task3', count: 1)
      expect(page).to have_content('ラスク4', count: 1)
      expect(page).to have_select('status', selected: '着手中')
    end
  end

  context '「Ruby」でラベル検索したとき' do
    let(:task_name) { '' }
    let(:status) { '指定しない' }
    let(:label) { 'Ruby' }

    scenario '検索結果は3件' do
      expect(page.all('tbody tr').size).to eq 3
      expect(page).to have_select('label', selected: 'Ruby')
    end
  end

  context '「指定しない」でステータス検索したとき' do
    let(:task_name) { '' }
    let(:status) { '指定しない' }
    let(:label) { '指定しない' }

    scenario '検索結果は4件' do
      expect(page.all('tbody tr').size).to eq 4
      expect(page).to have_select('status', selected: '指定しない')
    end
  end

  context '名前&ステータス&ラベル検索したとき' do
    let(:task_name) { 'スク' }
    let(:status) { '着手中' }
    let(:label) { 'PHP' }

    scenario '検索結果は2件' do
      expect(page.all('tbody tr').size).to eq 2
      expect(page).to have_content('タスク1', count: 1)
      expect(page).to have_content('ラスク4', count: 1)
      expect(find_field('name').value).to eq 'スク'
      expect(page).to have_select('status', selected: '着手中')
      expect(page).to have_select('label', selected: 'PHP')
    end
  end

  context '検索後、期限で降順ソートしたとき' do
    let(:task_name) { 'スク' }
    let(:status) { '着手中' }
    let(:label) { 'PHP' }

    before { page.find('th', text: '期限').click_link('▼') }

    scenario '検索結果2件が期限で降順ソートされる' do
      until has_table?; end
      tr = page.all('tbody tr')

      expect(tr.size).to eq 2
      expect(tr[0].text).to have_content tasks[3].name
      expect(tr[1].text).to have_content tasks[0].name
      expect(find_field('name').value).to eq 'スク'
      expect(page).to have_select('status', selected: '着手中')
      expect(page).to have_select('label', selected: 'PHP')
    end
  end

  context '検索後、優先度で昇順ソートしたとき' do
    let(:task_name) { 'スク' }
    let(:status) { '着手中' }
    let(:label) { 'PHP' }

    before { page.find('th', text: '優先度').click_link('▲') }

    scenario '検索結果2件が優先度で昇順ソートされる' do
      until has_table?; end
      tr = page.all('tbody tr')

      expect(tr.size).to eq 2
      expect(tr[0].text).to have_content tasks[3].name
      expect(tr[1].text).to have_content tasks[0].name
      expect(find_field('name').value).to eq 'スク'
      expect(page).to have_select('status', selected: '着手中')
      expect(page).to have_select('label', selected: 'PHP')
    end
  end
end
