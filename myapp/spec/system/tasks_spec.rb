require "rails_helper"

RSpec.describe 'Tasks', type: :system, js: true do
  # let(:user) { create(:user, name: "hoge") }

  subject { visit root_path }
  it "タスク一覧表示" do
    subject
    expect(page).to have_content("Tasks#index")
  end
end
