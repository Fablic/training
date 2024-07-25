# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Session', type: :system do
  let(:user) { User.create(name: 'test', password: 'test') }

  before do
    visit session_path
  end

  it 'Sign in successful' do
    fill_in 'name', with: user.name
    fill_in 'password', with: user.password
    click_button 'commit'
    expect(page).to have_content('Tasks')
  end

  it 'Sign in failed with invalid session' do
    fill_in 'name', with: 'invalid'
    fill_in 'password', with: user.password
    click_button 'commit'
    expect(page).to have_content('Sign in to Tasks')
  end

  it 'Sign in failed with invalid password ' do
    fill_in 'name', with: user.name
    fill_in 'password', with: 'invalid'
    click_button 'commit'
    expect(page).to have_content('Sign in to Tasks')
  end

  it 'Sign out successful' do
    fill_in 'name', with: user.name
    fill_in 'password', with: user.password
    click_button 'commit'

    click_link 'sign_out'
    expect(page).to have_content('Sign in to Tasks')
  end
end
