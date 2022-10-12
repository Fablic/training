# frozen_string_literal: true

module AdminHelpers
  def can_not_access_admin_page
    visit admin_path

    expect(current_path).to eq admin_path
    expect(page).to have_content '404なので僕のせいじゃないっす'
    expect(page).to have_content '多分アドレスとか違うっす'
  end
end
