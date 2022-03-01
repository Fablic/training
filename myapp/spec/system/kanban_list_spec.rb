require 'rails_helper'

RSpec.describe 'Kanban', type: :system do
  feature 'kanban_list' do
    background do
      FactoryBot.create(:board)
      @board2 = FactoryBot.create(:board)

      @status1 = FactoryBot.create(:status, sort: 2)
      @status2 = FactoryBot.create(:status, sort: 3)
      @status3 = FactoryBot.create(:status, sort: 1)

      @priority1 = FactoryBot.create(:priority, sort: 1)
      @priority2 = FactoryBot.create(:priority, sort: 3)
      @priority3 = FactoryBot.create(:priority, sort: 2)

      @task1 = FactoryBot.create(:task, priority: @priority1, status: @status1, created_at: '2022-01-02')
      @task2 = FactoryBot.create(:task, priority: @priority2, status: @status2, created_at: '2022-01-01')
      @task3 = FactoryBot.create(:task, priority: @priority3, status: @status1, created_at: '2022-01-03')
      @task4 = FactoryBot.create(:task, priority: @priority3, status: @status3, created_at: '2022-01-04')
      FactoryBot.create(:task, board: @board2, priority: @priority1, status: @status1)

      Capybara.current_driver = Capybara.javascript_driver
      visit board_path({ 'id': '1', 'locale': 'en' })

      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
    end

    scenario 'order_desc' do
      page.find('span#sort_button').click
      page.find('div.sort_item', "text": 'Priority ▽').click

      # check sorted result
      titles = page.all(:css, '#kanban div.title')
      expect(titles[0].text).to eq(@task4.title)
      expect(titles[1].text).to eq(@task3.title)
      expect(titles[2].text).to eq(@task1.title)
      expect(titles[3].text).to eq(@task2.title)
    end

    scenario 'order_asc' do
      page.find('span#sort_button').click
      page.find('div.sort_item', "text": 'Priority ▽').click

      # check sorted result
      titles = page.all(:css, '#kanban div.title')
      expect(titles[0].text).to eq(@task4.title)
      expect(titles[1].text).to eq(@task3.title)
      expect(titles[2].text).to eq(@task1.title)
      expect(titles[3].text).to eq(@task2.title)
    end

    scenario 'visit kanban' do
      kanbans = page.all(:css, '#kanban > div')

      # should have 3 statuses
      expect(kanbans.length).to eq(3)

      # not started tab
      expect(kanbans[0].find(:css, 'div.card-title').text).to eq(@status3.title)
      cards = kanbans[0].all(:css, 'div.card')
      expect(cards.length).to eq(1)
      card_components = cards[0].all(:css, 'div')
      expect(card_components[0].text).to eq(@priority3.title)
      expect(card_components[1].text).to eq(@task4.title)
      expect(card_components[2].text).to eq('test')
      expect(card_components[3].text).to eq('Due Date: 2022/01/01 01:01')

      # in progress tab
      expect(kanbans[1].find(:css, 'div.card-title').text).to eq(@status1.title)
      cards = kanbans[1].all(:css, 'div.card')
      expect(cards.length).to eq(2)
      card_components = cards[0].all(:css, 'div')
      expect(card_components[0].text).to eq(@priority3.title)
      expect(card_components[1].text).to eq(@task3.title)
      expect(card_components[2].text).to eq('test')
      expect(card_components[3].text).to eq('Due Date: 2022/01/01 01:01')
      card_components = cards[1].all(:css, 'div')
      expect(card_components[0].text).to eq(@priority1.title)
      expect(card_components[1].text).to eq(@task1.title)
      expect(card_components[2].text).to eq('test')
      expect(card_components[3].text).to eq('Due Date: 2022/01/01 01:01')

      # closed tab
      expect(kanbans[2].find(:css, 'div.card-title').text).to eq(@status2.title)
      cards = kanbans[2].all(:css, 'div.card')
      expect(cards.length).to eq(1)
      card_components = cards[0].all(:css, 'div')
      expect(card_components[0].text).to eq(@priority2.title)
      expect(card_components[1].text).to eq(@task2.title)
      expect(card_components[2].text).to eq('test')
      expect(card_components[3].text).to eq('Due Date: 2022/01/01 01:01')
    end
  end
end
