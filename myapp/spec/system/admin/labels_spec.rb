# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do

  before do
    @admin = User.create(name: 'admin01', password: 'admin01', role: 'admin')
    visit session_path
    fill_in 'name', with: @admin.name
    fill_in 'password', with: @admin.password
    click_button 'commit'
  end

  describe 'list' do
    before do
      label1 = Label.create(name: 'label01')
      label2 = Label.create(name: 'label02')
      label3 = Label.create(name: 'label03')
      task1 = Task.create(title: 'title01', due_date: '2024-01-01', user_id: @admin.id)
      task2 = Task.create(title: 'title02', due_date: '2024-01-01', user_id: @admin.id)
      TaskLabelRelation.create(task_id: task1.id, label_id: label1.id)
      TaskLabelRelation.create(task_id: task2.id, label_id: label1.id)
      TaskLabelRelation.create(task_id: task1.id, label_id: label2.id)
      visit admin_labels_path
    end

    context 'When a label exists' do
      it 'Check the message and the order of labels' do
        expect(page).to have_content('Labels')
        expect(find('tr:nth-child(1) td:nth-child(1)').text).to eq('label01')
        expect(find('tr:nth-child(1) td:nth-child(2)').text).to eq('2')
        expect(find('tr:nth-child(2) td:nth-child(1)').text).to eq('label02')
        expect(find('tr:nth-child(2) td:nth-child(2)').text).to eq('1')
        expect(find('tr:nth-child(3) td:nth-child(1)').text).to eq('label03')
        expect(find('tr:nth-child(3) td:nth-child(2)').text).to eq('0')
      end
    end
  end

  describe 'Delete a label' do
    it 'standard user' do
      Label.create(name: 'label01')
      Label.create(name: 'label02')
      visit admin_labels_path
      expect(page).to have_content('label01')
      expect(page).to have_content('label02')
      click_button 'delete-1'
      expect(page).not_to have_content('label01')
      expect(page).to have_content('label02')
    end
  end
end
