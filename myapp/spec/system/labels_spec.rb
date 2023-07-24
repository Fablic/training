# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Labels' do
  describe 'page rendering' do
    before do
      create_test_users
      login_with_admin_user
    end

    let!(:label) { Label.last }

    it 'label list page should be shown' do
      visit '/labels'
      expect(page).to have_content 'Labels'
    end

    it 'labels should be listed in the label list page', :aggregate_failures do
      create(:label, name: 'test_label', user: User.last)
      visit '/labels'
      expect(page).to have_link 'test_label'
    end

    it 'label detail page should be shown' do
      label = create(:label, name: 'test_label', user: User.last)
      visit "/labels/#{label.id}"
      expect(page).to have_content 'Label detail'
    end

    it 'label edit page should be shown' do
      label = create(:label, name: 'test_label', user: User.last)
      visit "/labels/#{label.id}/edit"
      expect(page).to have_content 'Edit label'
    end

    it 'label create page should be shown' do
      visit '/labels/new'
      expect(page).to have_content 'New label'
    end
  end

  describe 'label creation' do
    before do
      create_test_users
      login_with_admin_user
    end

    it 'label created successfully & show flash message when label created', :aggregate_failures do
      visit '/labels'
      click_link('New label')
      fill_in 'label[name]', with: 'a_new_label'
      click_on 'Create Label'
      expect(page).to have_link 'a_new_label'
      expect(page).to have_content 'Label was successfully created.'
    end

    it 'label failed to be created due to empty name' do
      visit '/labels'
      click_link('New label')
      fill_in 'label[name]', with: ''
      click_on 'Create Label'
      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  describe 'label update' do
    before do
      create_test_users
      login_with_admin_user
    end

    it 'label name updated successfully from label lists page', :aggregate_failures do
      create(:label, name: 'label_before_edit', user: User.last)
      visit '/labels'
      click_on('Edit', match: :first)
      fill_in 'label[name]', with: 'label_after_edit'
      click_on 'Update Label'
      expect(page).to have_content 'label_after_edit'
      expect(page).to have_content 'Label was successfully updated.'
    end

    it 'label name updated successfully from label details page', :aggregate_failures do
      create(:label, name: 'label_before_edit', user: User.last)
      visit '/labels'
      click_link('label_before_edit')
      click_on('Edit')
      fill_in 'label[name]', with: 'label_after_edit'
      click_on 'Update Label'
      expect(page).to have_content 'label_after_edit'
      expect(page).to have_content 'Label was successfully updated.'
    end

    it 'label failed to be updated due to empty name' do
      create(:label, name: 'label_before_edit', user: User.last)
      visit '/labels'
      click_on('Edit', match: :first)
      fill_in 'label[name]', with: ''
      click_on 'Update Label'
      expect(page).to have_content 'Name can\'t be blank'
    end
  end

  describe 'label deletion' do
    before do
      create_test_users
      login_with_admin_user
    end

    it 'label deleted successfully & show flash message when label deleted', :aggregate_failures do
      create(:label, name: 'test_label', user: User.last)
      visit '/labels'
      click_on 'Delete'
      expect(page).not_to have_content 'test_label'
      expect(page).to have_content 'Label was successfully destroyed.'
    end
  end
end
