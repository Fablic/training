require 'rails_helper'

RSpec.describe "controllers/show", type: :view do
  before(:each) do
    assign(:controller, Controller.create!(
      Sessions: "Sessions",
      new: "New"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Sessions/)
    expect(rendered).to match(/New/)
  end
end
