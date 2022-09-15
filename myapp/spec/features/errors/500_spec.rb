# frozen_string_literal: true

require 'rails_helper'

RSpec.feature '500' do
  feature '#exception' do
    scenario 'correctly displays 500' do
      allow_any_instance_of(TasksController).to receive(:index).and_throw(Exception)
      visit tasks_path

      expect(page.status_code).to eq 500
      expect(page).to have_content '500っす。僕が原因っす'
    end
  end
end
