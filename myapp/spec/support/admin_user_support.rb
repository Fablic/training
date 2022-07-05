# frozen_string_literal: true

module AdminUserSupport
  def check_user_list(user, page)
    expect(page).to have_content user.id
    expect(page).to have_content user.name
    expect(page).to have_link "#{user.name}'s tasks", href: admin_users_tasks_path(user.id)
    expect(page).to have_content user.tasks.length
    expect(page).to have_content user.role
  end
end
