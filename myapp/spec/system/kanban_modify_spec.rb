require 'rails_helper'

RSpec.describe 'Kanban', type: :system do
  fixtures :boards, :tasks, :statuses, :priorities

  feature 'update_task' do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      visit board_path(1)

      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
    end

    scenario 'update_normal' do
      # open create modal
      cards = page.all(:css, 'div.card')
      cards[0].click

      # check old values
      expect(page.find('#edit_title').value).to eq('test 4')
      expect(page.find('#edit_status').value).to eq('3')
      expect(page.find('#edit_contents').value).to eq('test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test')
      expect(page.find('#edit_priority').value).to eq('3')
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
      page.select 'in progress', from: 'edit_status'
      page.select 'major', from: 'edit_priority'
      page.find('button', 'text': 'Save').click

      # wait for ajax
      expect(page).to have_selector('#modal_edit', visible: false)
      sleep(0.1)

      # confirm edited item
      cards = page.all(:css, 'div.card')
      expect(cards.length).to eq(4)
      cards = page.all(:css, '#kanban > div')[1].all(:css, 'div.card')
      card_components = cards[2].all(:css, 'div')
      expect(card_components[0].text).to eq('major')
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
      expect(page.find('#edit_title').value).to eq('test 4')
    end
  end
end
