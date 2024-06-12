require 'rails_helper'

RSpec.describe 'users/new', type: :view do
  before(:each) do
    assign(:user, User.new(
                    username: 'MyString',
                    password_digest: 'MyString',
                    role: 1
                  ))
  end

  it 'renders new user form' do
    render

    assert_select 'form[action=?][method=?]', users_path, 'post' do
      assert_select 'input[name=?]', 'user[username]'

      assert_select 'input[name=?]', 'user[password_digest]'

      assert_select 'input[name=?]', 'user[role]'
    end
  end
end
