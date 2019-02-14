# frozen_string_literal: true

# 各ユーザのタスク一覧画面に関するspec

require 'rails_helper'

feature '画面表示機能', type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  context 'ログインせず画面へアクセスしたとき' do
    before { visit tasks_admin_user_path(user) }

    scenario 'メッセージと共にログイン画面が表示される' do
      expect(current_path).to eq login_path
      expect(page).to have_selector('.alert-danger', text: 'サービスを利用するにはログインが必要です')
      expect(page).to have_selector('form', count: 1)
    end
  end

  context 'ログインした状態でアクセスしたとき' do
    before { login(user, tasks_admin_user_path(user)) }

    scenario 'ユーザのタスク一覧画面が表示される' do
      expect(current_path).to eq tasks_admin_user_path(user)
      expect(page).to have_content "#{user.email}のタスク一覧"
      expect(page).to have_selector('table', count: 1)
    end
  end
end

feature 'タスクソート機能', type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  let!(:tasks) {
    [
      FactoryBot.create(:task, name: 'タスク1', due_date: '20190203', priority: :middle, status: :in_progress, created_at: Time.zone.now, user: user),
      FactoryBot.create(:task, name: 'タスク2', due_date: '20190209', priority: :high,   status: :done,        created_at: 1.day.ago,     user: user),
      FactoryBot.create(:task, name: 'タスク3', due_date: '20190206', priority: :low,    status: :to_do,       created_at: 2.days.ago,    user: user),
    ]
  }

  shared_examples_for '任意の順でソートされる' do |options = {}|
    before do
      visit login(user, tasks_admin_user_path(user))
      until has_text?(options[:sort_column]); end
      page.find('th', text: options[:sort_column]).click_link(options[:direction]) if options[:sort_column].present? && options[:direction].present?
    end

    scenario '並び順が一致する' do
      until has_table?; end
      tr = page.all('tbody tr')

      tr.each.with_index do |element, i|
        expect(element.text).to have_content(tasks[options[:order][i]].name)
      end
    end
  end

  context '一覧画面で何もしないとき' do
    it_behaves_like '任意の順でソートされる', { order: [0, 1, 2] }
  end

  context '列「登録日時」の「▲/▼」をクリックした時' do
    it_behaves_like '任意の順でソートされる', { sort_column: '登録日時', direction: '▲', order: [2, 1, 0] }
    it_behaves_like '任意の順でソートされる', { sort_column: '登録日時', direction: '▼', order: [0, 1, 2] }
  end

  context '列「優先度」の「▲/▼」をクリックした時' do
    it_behaves_like '任意の順でソートされる', { sort_column: '優先度', direction: '▲', order: [2, 0, 1] }
    it_behaves_like '任意の順でソートされる', { sort_column: '優先度', direction: '▼', order: [1, 0, 2] }
  end

  context '列「期限」の「▲/▼」をクリックした時' do
    it_behaves_like '任意の順でソートされる', { sort_column: '期限', direction: '▲', order: [0, 2, 1] }
    it_behaves_like '任意の順でソートされる', { sort_column: '期限', direction: '▼', order: [1, 2, 0] }
  end
end

feature 'ページネーション機能', type: :feature do
  let!(:user) { FactoryBot.create(:user) }
  let!(:tasks) { 10.times { FactoryBot.create(:task, user: user) } }

  before { login(user, tasks_admin_user_path(user)) }

  context 'タスク件数が10件のとき' do
    scenario '1ページ目に6件表示される' do
      expect(page).to have_content '全10件中1 - 6件のタスクが表示されています'
      expect(page).to have_link '次 ›'
      expect(page).to have_no_link '‹ 前'
      expect(page.all('tbody tr').size).to eq 6
    end

    scenario '2ページ目に4件表示される' do
      find_link('次').click
      expect(page).to have_content '全10件中7 - 10件のタスクが表示されています'
      expect(page).to have_link '‹ 前'
      expect(page).to have_no_link '次 ›'
      expect(page.all('tbody tr').size).to eq 4
    end
  end
end
