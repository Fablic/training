# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/users/new', type: :view do
  let!(:user) { assign(:user, build(:user)) }

  it 'renders new user form' do
    render

    assert_select 'form[action=?][method=?]', admin_users_path, 'post' do
      assert_select 'input[name=?]', 'user[name]'
      assert_select 'input[name=?]', 'user[email]'
      assert_select 'input[name=?]', 'user[password]'
    end
  end
end
