require 'rails_helper'

RSpec.describe "Error Pages", type: :system do
  it "displays the not found error page in English" do
    visit "/non_existent_path?locale=en"
    expect(page).to have_content("Page not found")
  end

  it "displays the not found error page in Japanese" do
    visit "/non_existent_path?locale=ja"
    expect(page).to have_content("ページが見つかりません")
  end

  it "displays the internal server error page in English" do
    allow_any_instance_of(TasksController).to receive(:index).and_throw(Exception)
    visit "/tasks?locale=en"
    expect(page).to have_content("Internal Server Error")
  end

  it "displays the internal server error page in Japanese" do
    allow_any_instance_of(TasksController).to receive(:index).and_throw(Exception)
    visit "/tasks?locale=ja"
    expect(page).to have_content("サーバー内部エラー")
  end
end