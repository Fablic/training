feature 'tasks', type: :system, js: true do

  scenario 'create tasks scenario' do
      visit new_task_path
      fill_in 'task[title]', with: 'test title'
      fill_in 'task[body]', with: 'test body'
      fill_in 'task[deadline]', with: '02-02-2022'

      click_button 'commit'
      page.driver.browser.switch_to.alert.accept

      expect(current_path).to eq root_path
      expect(page).to have_content 'test title'

      click_on '#', match: :first
      expect(page).to have_content 'test title'
      expect(page).to have_content 'test body'
    end

    scenario 'edit tasks scenario' do
      visit root_path
      click_on '#', match: :first
      click_button '編集', match: :first
      fill_in 'task[title]', with: 'edit test title'
      fill_in 'task[body]', with: 'edit test body'
      fill_in 'task[deadline]', with: '03-03-2033'

      click_button 'commit'
      page.driver.browser.switch_to.alert.accept

      expect(current_path).to eq root_path
      expect(page).to have_content 'edit test title'
    end

    scenario 'delete task scenario' do
      visit root_path
      click_on '#', match: :first
      click_button '削除', match: :first

      expect(page).not_to have_content 'edit test title'
    end
  end
