# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'error_page', type: :sytem do
  describe 'page not found', :require_login do
    it 'display not found page' do
      visit '404test/task'

      expect(page).to have_content(I18n.t('common.error.not_found'))
    end
  end

  describe 'internal_server_error', :require_login do
    it 'display internal server error page' do
      allow_any_instance_of(TasksController).to receive(:index).and_throw(StandardError)
      visit tasks_path

      expect(page).to have_content(I18n.t('common.error.internal_server_error'))
    end
  end
end
