# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sessions/new', type: :view do
  it 'renders new user form' do
    render

    expect(rendered).to match(/ログインする/)
    assert_select 'form[action=?][method=?]', '/login', 'post' do
      assert_select 'input[name=?]', 'session[email]'
      assert_select 'input[name=?]', 'session[password]'
    end
  end
end
