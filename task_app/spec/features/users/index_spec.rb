# frozen_string_literal: true

require 'rails_helper'

feature '画面表示機能', type: :feature do
  let!(:user1) { FactoryBot.create(:user, email: 'user1@example.com') }
  let!(:user2) { FactoryBot.create(:user, email: 'user2@example.com') }

  context 'ログインせず画面へアクセスしたとき' do
    before { visit admin_root_path }

    scenario 'メッセージと共にログイン画面が表示される' do
      expect(current_path).to eq login_path
      expect(page).to have_selector('.alert-danger', text: 'サービスを利用するにはログインが必要です')
      expect(page).to have_selector('form', count: 1)
    end
  end

  context 'user1でログインした状態でアクセスしたとき' do
    before do
      3.times { FactoryBot.create(:task, user: user1) }
      2.times { FactoryBot.create(:task, user: user2) }
    end

    before { login(user1, admin_root_path) }

    scenario 'ユーザ一覧画面が表示され、ユーザ数と各ユーザのタスク数を確認できる' do
      expect(current_path).to eq admin_root_path
      expect(page.all('tbody tr').size).to eq 2
      expect(page).to have_content(user1.email, count: 1)
      expect(page).to have_content(user2.email, count: 1)
      expect(page.find('tr', text: user1.email).text).to include('3')
      expect(page.find('tr', text: user2.email).text).to include('2')
    end
  end
end

feature 'ユーザ削除機能', type: :feature do
  let!(:user1) { FactoryBot.create(:user, email: 'user1@example.com') }
  let!(:user2) { FactoryBot.create(:user, email: 'user2@example.com') }

  before do
    2.times { FactoryBot.create(:task, user: user2) }
    login(user1, admin_root_path)
  end

  context 'user1でログイン後、user2を削除する確認ダイアログでOKを押したとき' do
    scenario 'user2は削除され、ユーザ一覧画面にメッセージが表示される' do
      page.find('tr', text: user2.email).click_link('削除')
      page.accept_confirm
      expect(page).to have_selector '.alert-success', text: 'ユーザ「user2@example.com」を削除しました。'
      expect(page.all('tbody tr').size).to eq 1
      expect(Task.where(user_id: user2.id).count).to eq 0
    end
  end

  context 'user1でログイン後、user2を削除する確認ダイアログでキャンセルを押したとき' do
    scenario 'user2は削除されず、そのままユーザ一覧画面が表示される' do
      page.find('tr', text: user2.email).click_link('削除')
      page.dismiss_confirm
      expect(page).to have_no_selector '.alert-success', text: 'ユーザ「user2@example.com」を削除しました。'
      expect(page.all('tbody tr').size).to eq 2
      expect(page.find('tr', text: user2.email).text).to include('2')
    end
  end

  context 'user1でログイン時、自身のアカウントを削除しようとしたとき' do
    scenario 'ユーザ一覧画面に削除するリンクは存在しない' do
      expect(page.find('tr', text: user1.email)).to have_no_link('削除')
    end
  end
end

feature 'ユーザ検索機能', type: :feature do
  let!(:user1) { FactoryBot.create(:user, email: 'user1@example.com') }
  let!(:user2) { FactoryBot.create(:user, email: 'user2@example.com') }

  before do
    login(user1, admin_root_path)
    fill_in 'email', with: email
    click_on('検索')
  end

  context '「user1」でアドレス検索をしたとき' do
    let(:email) { 'user1' }

    scenario '検索結果は1件' do
      expect(page.all('tbody tr').size).to eq 1
      expect(page).to have_content(user1.email, count: 1)
      expect(find_field('email').value).to eq 'user1'
    end
  end

  context '「hoge」でアドレス検索をしたとき' do
    let(:email) { 'hoge' }

    scenario '検索結果は0件' do
      expect(page.all('tbody tr').size).to eq 0
      expect(find_field('email').value).to eq 'hoge'
    end
  end
end

feature 'ページネーション機能', type: :feature do
  let!(:user1) { FactoryBot.create(:user, email: 'user1@example.com') }

  before do
    (2..10).each { |i| FactoryBot.create(:user, email: "user#{i}@example.com") }
    login(user1, admin_root_path)
  end

  context 'ユーザ数が10のとき' do
    scenario '1ページ目に6ユーザが表示される' do
      expect(page).to have_content '全10件中1 - 6件のユーザが表示されています'
      expect(page).to have_link '次 ›'
      expect(page).to have_no_link '‹ 前'
      expect(page.all('tbody tr').size).to eq 6
    end

    scenario '2ページ目に4ユーザが表示される' do
      find_link('次').click
      expect(page).to have_content '全10件中7 - 10件のユーザが表示されています'
      expect(page).to have_link '‹ 前'
      expect(page).to have_no_link '次 ›'
      expect(page.all('tbody tr').size).to eq 4
    end
  end
end
