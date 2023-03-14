require 'rails_helper'

RSpec.describe "controllers/index", type: :view do
  before(:each) do
    assign(:controllers, [
      Controller.create!(
        Sessions: "Sessions",
        new: "New"
      ),
      Controller.create!(
        Sessions: "Sessions",
        new: "New"
      )
    ])
  end

  it "renders a list of controllers" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Sessions".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("New".to_s), count: 2
  end
end
