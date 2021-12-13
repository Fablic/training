# frozen_string_literal: true

module LoginModule
  def login_as(user)
    visit login_path
    fill_in 'session[email]', with: user.email
    fill_in 'session[password]', with: user.password
    find('[name=commit]').click
  end
end
