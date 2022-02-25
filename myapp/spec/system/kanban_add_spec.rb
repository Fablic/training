require "rails_helper"

RSpec.describe 'Kanban', type: :system do
  fixtures :boards, :tasks, :statuses, :priorities

  feature "create_task" do
    background do
      Capybara.current_driver = Capybara.javascript_driver
      visit board_path({'id':'1', 'locale':'en'})

      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 

    end

    scenario "create_normal" do
      cards = page.all(:css, 'div.card')
      expect(cards.length).to eq(4)

      page.click_link("New")
      page.fill_in "edit_title", with:"sample title"
      page.fill_in "edit_due_date", with: "2022-05-01 01:01"

      page.find(:css, "#edit_due_date").click()
      # since datetimepicker modal not open sometimes
      while !have_selector("div.xdsoft_time", "text": "03:00")
        page.find(:css, "#edit_due_date").click()
        sleep 0.1
      end
      page.find("div.xdsoft_time", "text": "03:00").click()
      page.fill_in "edit_contents", with:"sample contents"
      page.select "in progress", :from => "edit_status"
      page.select "minor", :from => "edit_priority"
      page.find('button', 'text': 'Save').click()

      # wait for ajax
      expect(page).to have_selector("#modal_edit", visible: false) 
      sleep(0.1)

      # confirm newly added item
      cards = page.all(:css, 'div.card')
      expect(cards.length).to eq(5)
      cards = page.all(:css, '#kanban > div')[1].all(:css, 'div.card')
      card_components = cards[2].all(:css, 'div')
      expect(card_components[0].text).to eq("minor")
      expect(card_components[1].text).to eq("sample title")
      expect(card_components[2].text).to eq("sample contents")
      expect(card_components[3].text).to eq("Due Date: 2022/05/01 03:00")

    end

    scenario "cancel_by_clicking_mask" do
      # open new tab
      page.click_link("New")

      # write something and confirm
      page.fill_in "edit_title", with:"sample title"
      expect(page.find("#edit_title").value).to eq("sample title")

      # close tab and confirm
      page.find("#modal_background").click()
      expect(page).to have_selector("#modal_edit", visible: false)

      # open new tab again, and see input values are cleared
      page.click_link("New")
      expect(page.find("#edit_title").value).to eq("")
    end

  end
end
