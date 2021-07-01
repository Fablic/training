module LoginHelper
  def login(user)
    visit login_path
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: 'abc1234'
    click_button('Login')
    expect(page).to have_text user.name
  end
end