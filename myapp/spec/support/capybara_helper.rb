module CapybaraHelper
  def login_as(user)
    visit '/login'

    fill_in 'Name', with: user.name
    fill_in 'Password', with: user.password
    click_button 'Login'
  end

  def logout
    visit '/'
    click_link 'Logout'
  end

  def have_spec(value, **kw_args)
    have_selector("[data-spec='#{value}']", **kw_args)
  end

  def within_spec(value, **kw_args, &block)
    within("[data-spec='#{value}']", **kw_args, &block)
  end
end
