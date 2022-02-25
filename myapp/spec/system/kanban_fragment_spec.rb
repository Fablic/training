require "rails_helper"

RSpec.describe 'Kanban', type: :system do
  fixtures :boards, :tasks, :statuses, :priorities

  feature "fragment" do
    background do
      Capybara.current_driver = Capybara.javascript_driver
    end

    scenario "without_fragment" do
      visit "/en/board/1"
      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 
      sleep(0.1)

      # check fragment
      expect(URI::parse(page.current_url).fragment).to eq("kanban")
      
      # check view/edit modal is not visible
      expect(page).to have_selector("#modal_edit", visible: false)

    end

    scenario "kanban_mode" do
      visit "/en/board/1#kanban"
      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 
      sleep(0.1)

      # check fragment
      expect(URI::parse(page.current_url).fragment).to eq("kanban")
      
      # check view/edit modal is not visible
      expect(page).to have_selector("#modal_edit", visible: false)

    end

    scenario "unexpected_fragment" do
      visit "/en/board/1#anything"
      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 
      sleep(0.1)

      # check fragment
      expect(URI::parse(page.current_url).fragment).to eq("kanban")
      
      # check view/edit modal is not visible
      expect(page).to have_selector("#modal_edit", visible: false)

    end

    scenario "create_mode_and_cancel" do
      visit "/en/board/1#create"
      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 
      sleep(0.1)

      # check fragment
      expect(URI::parse(page.current_url).fragment).to eq("create")
      
      # check view/edit modal is visible
      expect(page).to have_selector("#modal_edit", visible: true)

      # close modal and confirm
      page.find("#modal_background").click()
      expect(page).to have_selector("#modal_edit", visible: false)

      # check fragment
      expect(URI::parse(page.current_url).fragment).to eq("kanban")

    end

    scenario "modify_mode_and_cancel" do
      visit "/en/board/1#modify&id=2"
      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 
      sleep(0.1)

      # check fragment
      expect(URI::parse(page.current_url).fragment).to eq("modify&id=2")
      
      # check view/edit modal is visible
      expect(page).to have_selector("#modal_edit", visible: true)

      # check valid item is showing in edit modal
      expect(page.find("#edit_title").value).to eq("test 2")

      # close modal and confirm
      page.find("#modal_background").click()
      expect(page).to have_selector("#modal_edit", visible: false)

      # check fragment
      expect(URI::parse(page.current_url).fragment).to eq("kanban")

    end

    scenario "modify_mode_wrong_id" do
      visit "/en/board/1#modify&id=999999"
      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 
      sleep(0.1)

      # check fragment
      expect(URI::parse(page.current_url).fragment).to eq("kanban")

      # check view/edit modal is not visible
      expect(page).to have_selector("#modal_edit", visible: false)

    end



  end
end
