require 'rails_helper'

RSpec.describe 'users/index', type: :view do
  before(:each) do
    assign(:users, [
             User.create!(
               username: 'Username',
               password_digest: 'Password Digest',
               role: 2
             ),
             User.create!(
               username: 'Username',
               password_digest: 'Password Digest',
               role: 2
             )
           ])
  end

  it 'renders a list of users' do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new('Username'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new('Password Digest'.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
