# frozen_string_literal: true

module RakeTaskHelpers
  def display_503(path)
    visit path

    expect(page).to have_content 'メンテ中っすー'
    expect(page).to have_content 'ちょい待ちっす'
  end
end
