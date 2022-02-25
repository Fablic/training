require "rails_helper"

RSpec.describe 'I18n', type: :system do
  fixtures :boards, :tasks, :statuses, :priorities

  feature "i18n" do
    background do
      Capybara.current_driver = Capybara.javascript_driver

    end

    scenario "default_language" do
      visit '/'
      expect(URI::parse(page.current_url).path).to eq('/en/board/1')
      
    end

    scenario "en" do
      visit board_path({'id':'1', 'locale':'en'})

      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 

      expect(page.find("a.btn-success").text).to eq("New")
    end

    scenario "ja" do
      visit board_path({'id':'1', 'locale':'ja'})

      # wait for ajax
      expect(page).to have_selector("#kanban > div", visible: false) 

      expect(page.find("a.btn-success").text).to eq("追加")
    end

    
  end
end
