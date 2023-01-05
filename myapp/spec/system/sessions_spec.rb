# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Session', type: :system do
  describe '#new' do
    before { visit new_session_path }
    context 'when user data exists' do
      let!(:user) { create(:user, password: '123') }
      it 'creates a session and stores user_id' do
        expect(RSpec.configuration.session[:user_id]).to be_nil

        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        click_button 'Log In'

        expect(RSpec.configuration.session[:user_id]).to eq(user.id)
      end
    end

    context 'when user data does not exist' do
      let(:user) { build(:user, password: '123') }
      it 'does not create a session nor store user_id' do
        expect(RSpec.configuration.session[:user_id]).to be_nil

        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        click_button 'Log In'

        expect(RSpec.configuration.session[:user_id]).to be_nil
      end
    end
  end

  describe '#destroy' do
    let(:user) { create(:user, password: '123') }
    let(:rspec_session) { {user_id: user.id} }

    it 'clears user session' do
      expect(RSpec.configuration.session[:user_id]).to eq(user.id)
      visit logout_path

      expect(RSpec.configuration.session[:user_id]).to be_nil
    end
  end
end
