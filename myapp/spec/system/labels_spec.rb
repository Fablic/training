require 'rails_helper'

RSpec.describe LabelsController, type: :system do
  let(:user) { create(:user) }

  before do
    login_as user
  end

  describe 'Labels page' do
    it 'lets a user show labels' do
      label1 = create(:label, user: user, name: 'security', color: '#f00')
      label2 = create(:label, user: user, name: 'bug', color: '#0f0')

      visit '/labels'

      expect(page).to have_text 'The list of labels'
      expect(page).to have_link 'New', href: '/en/labels/new'
      expect(page).to have_link 'security', href: "/en/labels/#{label1.id}/edit"
      expect(page).to have_link 'bug', href: "/en/labels/#{label2.id}/edit"
    end

    it 'redirects the user without session' do
      logout

      visit '/labels'

      expect(page).to have_current_path('/en/login')
      expect(page).to have_text('You must login beforehand')
    end
  end

  describe 'Label new page' do
    it 'lets a user create a label' do
      visit '/labels'

      click_link 'New'
      fill_in 'Name', with: 'new label'
      fill_in 'Color', with: '#ff7890'
      click_button 'Submit'

      expect(page).to have_current_path('/en/labels')
      expect(page).to have_text 'Succeeded to add the label!'
      label = Label.find_by!(name: 'new label')
      expect(page).to have_link label.name, href: "/en/labels/#{label.id}/edit"
    end

    it 'redirects the user without session' do
      logout

      visit '/labels/new'

      expect(page).to have_current_path('/en/login')
      expect(page).to have_text('You must login beforehand')
    end
  end

  describe 'Label edit page' do
    it 'lets a user edit a label' do
      label = create(:label, user: user, name: 'My cool label', color: '#fff')

      visit '/labels'

      click_link 'My cool label'
      fill_in 'Name', with: 'My coolest label'
      click_button 'Submit'

      expect(page).to have_current_path('/en/labels')
      expect(page).to have_text 'Succeeded to edit the label!'
      expect(page).to have_link 'My coolest label', href: "/en/labels/#{label.id}/edit"
    end

    it 'lets a user delete the label' do
      create(:label, user: user, name: 'My cool label', color: '#fff')

      visit '/labels'

      click_link 'My cool label'
      click_link 'Delete'

      accept_alert 'Are you sure you want to delete the label?'

      expect(page).to have_current_path('/en/labels')
      expect(page).to have_text 'Succeeded to delete the label!'

      expect(page).not_to have_text 'My cool label'
    end

    it 'redirects the user without session' do
      label = create(:label, user: user, name: 'My cool label', color: '#fff')

      logout

      visit "/labels/#{label.id}/edit"

      expect(page).to have_current_path('/en/login')
      expect(page).to have_text('You must login beforehand')
    end
  end
end
