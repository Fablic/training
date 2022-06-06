require 'rails_helper'

RSpec.describe 'Kanban', type: :system do
  feature 'delete_task' do
    background do
      board = FactoryBot.create(:board)

      status = FactoryBot.create(:status, sort: 2)
      priority = FactoryBot.create(:priority, sort: 1)

      @task1 = FactoryBot.create(:task, priority: priority, status: status, created_at: '2022-01-02')
      @task2 = FactoryBot.create(:task, priority: priority, status: status, created_at: '2022-01-01')
      @task3 = FactoryBot.create(:task, priority: priority, status: status, created_at: '2022-01-03')

      user = FactoryBot.create(:user, email: 'admin@example.com', permissions: 1)
      FactoryBot.create(:boards_user, board_id: board.id, user_id: user.id, permissions: 7)

      Capybara.current_driver = Capybara.javascript_driver

      visit login_path({'locale': 'en'})

      page.fill_in 'email', with: user.email
      page.fill_in 'password', with: 'test'
      page.find('input.btn').click

      # wait for redirect
      expect(page).to have_selector('#kanban')

      visit board_path({ 'id': '1', 'locale': 'en' })

      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
    end

    scenario 'delete_normal' do
      # check initial state
      cards = page.all(:css, 'div.card')
      expect(cards.length).to eq(3)

      # selete item to remove
      cards = page.all(:css, 'div.card')
      cards[0].click

      page.click_link('Delete')

      # wait for ajax
      expect(page).to have_selector('#modal_edit', visible: false)
      sleep(0.1)

      # confirm removed
      cards = page.all(:css, 'div.card')
      expect(cards.length).to eq(2)

      # check remain items
      expect(cards[0].find('div.title').text).to eq(@task1.title)
      expect(cards[1].find('div.title').text).to eq(@task2.title)
    end
  end
end
