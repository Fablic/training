require "../rails_helper"

RSpec.describe 'Kanban', type: :system do
  fixtures :boards, :tasks, :statuses, :priorities

  feature "kanban_list" do

    background do
      Capybara.current_driver = Capybara.javascript_driver
      visit board_path(1)
      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 

    end

    scenario "visit kanban" do
      kanbans = page.all(:css, '#kanban > div')

      # should have 3 statuses
      expect(kanbans.length).to eq(3)

      # not started tab
      expect(kanbans[0].find(:css, 'div.card-title').text).to eq("not started")
      cards = kanbans[0].all(:css, 'div.card')
      expect(cards.length).to eq(1)
      card_components = cards[0].all(:css, 'div')
      expect(card_components[0].text).to eq("major")
      expect(card_components[1].text).to eq("test 4")
      expect(card_components[2].text).to eq("test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test test")
      expect(card_components[3].text).to eq("Due Date: 2022/01/01 01:01")

      # in progress tab
      expect(kanbans[1].find(:css, 'div.card-title').text).to eq("in progress")
      cards = kanbans[1].all(:css, 'div.card')
      expect(cards.length).to eq(2)
      card_components = cards[0].all(:css, 'div')
      expect(card_components[0].text).to eq("critical")
      expect(card_components[1].text).to eq("test 1")
      expect(card_components[2].text).to eq("test")
      expect(card_components[3].text).to eq("Due Date: 2022/01/01 01:01")
      card_components = cards[1].all(:css, 'div')
      expect(card_components[0].text).to eq("major")
      expect(card_components[1].text).to eq("test 3")
      expect(card_components[2].text).to eq("test")
      expect(card_components[3].text).to eq("Due Date: 2022/01/01 01:01")

      # closed tab
      expect(kanbans[2].find(:css, 'div.card-title').text).to eq("closed")
      cards = kanbans[2].all(:css, 'div.card')
      expect(cards.length).to eq(1)
      card_components = cards[0].all(:css, 'div')
      expect(card_components[0].text).to eq("minor")
      expect(card_components[1].text).to eq("test 2")
      expect(card_components[2].text).to eq("test")
      expect(card_components[3].text).to eq("Due Date: 2022/01/01 01:01")
    end

  end

end
