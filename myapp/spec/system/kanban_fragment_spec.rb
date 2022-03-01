require 'rails_helper'

RSpec.describe 'Kanban', type: :system do
  feature 'fragment' do
    background do
      FactoryBot.create(:board)

      status = FactoryBot.create(:status, sort: 2)
      priority = FactoryBot.create(:priority, sort: 1)

      FactoryBot.create(:task, priority: priority, status: status, created_at: '2022-01-02')
      @task2 = FactoryBot.create(:task, priority: priority, status: status, created_at: '2022-01-01')
      FactoryBot.create(:task, priority: priority, status: status, created_at: '2022-01-03')

      Capybara.current_driver = Capybara.javascript_driver
    end

    scenario 'without_fragment' do
      visit '/en/board/1'
      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
      sleep(0.1)

      # check fragment
      expect(URI.parse(page.current_url).fragment).to eq('kanban&sort=-created_at')

      # check view/edit modal is not visible
      expect(page).to have_selector('#modal_edit', visible: false)

      # check view/edit modal is not visible
      expect(page).to have_selector('#modal_edit', visible: false)
    end

    scenario 'kanban_mode' do
      visit '/en/board/1#kanban'
      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
      sleep(0.1)

      # check fragment
      expect(URI.parse(page.current_url).fragment).to eq('kanban&sort=-created_at')

      # check view/edit modal is not visible
      expect(page).to have_selector('#modal_edit', visible: false)

      # check view/edit modal is not visible
      expect(page).to have_selector('#modal_edit', visible: false)
    end

    scenario 'unexpected_fragment' do
      visit '/en/board/1#anything'
      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
      sleep(0.1)

      # check fragment
      expect(URI.parse(page.current_url).fragment).to eq('kanban&sort=-created_at')

      # check view/edit modal is not visible
      expect(page).to have_selector('#modal_edit', visible: false)

      # check view/edit modal is not visible
      expect(page).to have_selector('#modal_edit', visible: false)
    end

    scenario 'create_mode_and_cancel' do
      visit '/en/board/1#create'
      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
      sleep(0.1)

      # check fragment
      expect(URI.parse(page.current_url).fragment).to eq('create')

      # check view/edit modal is visible
      expect(page).to have_selector('#modal_edit', visible: true)

      # close modal and confirm
      page.find('#modal_background').click
      expect(page).to have_selector('#modal_edit', visible: false)

      # check fragment
      expect(URI.parse(page.current_url).fragment).to eq('kanban&sort=-created_at')
    end

    scenario 'modify_mode_and_cancel' do
      visit '/en/board/1#modify&id=2'
      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
      sleep(0.1)

      # check fragment
      expect(URI.parse(page.current_url).fragment).to eq('modify&id=2')

      # check view/edit modal is visible
      expect(page).to have_selector('#modal_edit', visible: true)

      # check valid item is showing in edit modal
      expect(page.find('#edit_title').value).to eq(@task2.title)

      # close modal and confirm
      page.find('#modal_background').click
      expect(page).to have_selector('#modal_edit', visible: false)

      # check fragment
      expect(URI.parse(page.current_url).fragment).to eq('kanban&sort=-created_at')
    end

    scenario 'modify_mode_wrong_id' do
      visit '/en/board/1#modify&id=999999'
      # wait for ajax
      expect(page).to have_selector('#kanban > div', visible: false)
      sleep(0.1)

      # check fragment
      expect(URI.parse(page.current_url).fragment).to eq('kanban&sort=-created_at')

      # check view/edit modal is not visible
      expect(page).to have_selector('#modal_edit', visible: false)
    end
  end
end
