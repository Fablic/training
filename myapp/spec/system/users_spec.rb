# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { create(:user, name: 'test1', email: 'test1@gmail.com', admin: true) }

  before do
    login(user: user)
  end

  describe '#show' do
    it 'display user info', :aggregate_failures do
      visit user_path(user.id)
      expect(page).to have_content 'test1'
      expect(page).to have_content 'test1@gmail.com'
    end
  end
end
