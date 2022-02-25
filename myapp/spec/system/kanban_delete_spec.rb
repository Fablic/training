require "rails_helper"

RSpec.describe 'Kanban', type: :system do
  fixtures :boards, :tasks, :statuses, :priorities

  feature "delete_task" do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      visit board_path({'id':'1', 'locale':'en'})

      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 

    end

    scenario "delete_normal" do
      # check initial state
      cards = page.all(:css, 'div.card')
      expect(cards.length).to eq(4)

      # selete item to remove
      cards = page.all(:css, 'div.card')
      cards[0].click()

      page.click_link("Delete")
      
      # wait for ajax
      expect(page).to have_selector("#modal_edit", visible: false) 
      sleep(0.1)

      # confirm removed
      cards = page.all(:css, 'div.card')
      expect(cards.length).to eq(3)

      # check remain items
      expect(cards[0].find("div.title").text).to eq("test 1")
      expect(cards[1].find("div.title").text).to eq("test 3")
      expect(cards[2].find("div.title").text).to eq("test 2")

    end

  end
end
