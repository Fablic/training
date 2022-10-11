# frozen_string_literal: true

module AdminHelpers
  def can_not_access_admin_page
    visit admin_path

    expect(current_path).to eq root_path
    expect(page).to have_content '権限がないため管理者ページを開くことが出来ません'
  end
end
