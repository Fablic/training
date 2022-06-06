require 'rails_helper'

RSpec.describe 'Kanban', type: :system do
  feature 'update_task' do
    background do
      board = FactoryBot.create(:board)

      @status1 = FactoryBot.create(:status, sort: 2)
      @status2 = FactoryBot.create(:status, sort: 3)
      @status3 = FactoryBot.create(:status, sort: 1)

      @priority1 = FactoryBot.create(:priority, sort: 1)
      @priority2 = FactoryBot.create(:priority, sort: 3)
      @priority3 = FactoryBot.create(:priority, sort: 2)
      @task1 = FactoryBot.create(:task, priority: @priority1, status: @status1)

      FactoryBot.create(:status_step, from_status: @status3, to_status: @status1)
      FactoryBot.create(:status_step, from_status: @status1, to_status: @status3)
      FactoryBot.create(:status_step, from_status: @status1, to_status: @status2)
      FactoryBot.create(:status_step, from_status: @status2, to_status: @status1)
    
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

    scenario 'update_normal' do
      # open create modal
      cards = page.all(:css, 'div.card')
      cards[0].click

      # check old values
      expect(page.find('#edit_title').value).to eq(@task1.title)
      expect(page.find('#edit_status').value).to eq(@status1.id.to_s)
      expect(page.find('#edit_contents').value).to eq('test')
      expect(page.find('#edit_priority').value).to eq(@priority1.id.to_s)
      expect(page.find('#edit_due_date').value).to eq('2022/01/01 01:01')

      page.fill_in 'edit_title', with: 'title_modified'
      page.find(:css, '#edit_due_date').click
      # since datetimepicker modal not open sometimes
      until have_selector('div.xdsoft_time', "text": '02:00')
        page.find(:css, '#edit_due_date').click
        sleep 0.1
      end
      page.find('div.xdsoft_time', "text": '02:00').click
      page.fill_in 'edit_contents', with: 'contents modified'
      page.select @status2.title, from: 'edit_status'
      page.select @priority2.title, from: 'edit_priority'
      page.find('button', 'text': 'Save').click

      # wait for ajax
      expect(page).to have_selector('#modal_edit', visible: false)
      sleep(0.1)

      # confirm edited item
      cards = page.all(:css, '#kanban > div')[2].all(:css, 'div.card')
      card_components = cards[0].all(:css, 'div')
      expect(card_components[0].text).to eq(@priority2.title)
      expect(card_components[1].text).to eq('title_modified')
      expect(card_components[2].text).to eq('contents modified')
      expect(card_components[3].text).to eq('Due Date: 2022/01/01 02:00')
    end

    scenario 'cancel_by_clicking_mask' do
      # open new tab
      cards = page.all(:css, 'div.card')
      cards[0].click

      # write something and confirm
      page.fill_in 'edit_title', with: 'sample title'
      expect(page.find('#edit_title').value).to eq('sample title')

      # close tab and confirm
      page.find('#modal_background').click
      expect(page).to have_selector('#modal_edit', visible: false)

      # open new tab again, and see input values are discarded
      cards = page.all(:css, 'div.card')
      cards[0].click
      expect(page.find('#edit_title').value).to eq(@task1.title)
    end
  end
end
