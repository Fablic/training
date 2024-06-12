require 'rails_helper'

RSpec.describe 'users/edit', type: :view do
  let(:user) do
    User.create!(
      username: 'MyString',
      password_digest: 'MyString',
      role: 1
    )
  end

  before(:each) do
    assign(:user, user)
  end

  it 'renders the edit user form' do
    render

    assert_select 'form[action=?][method=?]', user_path(user), 'post' do
      assert_select 'input[name=?]', 'user[username]'

      assert_select 'input[name=?]', 'user[password_digest]'

      assert_select 'input[name=?]', 'user[role]'
    end
  end
end
